import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'simple_product_provider.dart';
import '../services/cart_service.dart';

class SimpleCartItem {
  final String productId;
  final String name;
  final double price;
  int quantity;

  SimpleCartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  // Create from JSON
  factory SimpleCartItem.fromJson(Map<String, dynamic> json) {
    return SimpleCartItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }
}

class SimpleCartProvider with ChangeNotifier {
  final List<SimpleCartItem> _items = [];
  late SharedPreferences _prefs;
  late CartService _cartService;
  bool _isInitialized = false;
  bool _isSyncingWithFirebase = false;

  static const String _cartStorageKey = 'simple_cart_items';

  List<SimpleCartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isInitialized => _isInitialized;
  bool get isSyncingWithFirebase => _isSyncingWithFirebase;

  // ✅ Initialize Preferences and Cart Service
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _cartService = CartService();
      
      // Load from local storage first
      await _loadCartFromStorage();
      
      // Then sync with Firebase if user is logged in
      await _syncWithFirebase();
      
      _isInitialized = true;
      notifyListeners();
      if (kDebugMode) {
        print('✅ Cart initialized with ${_items.length} items');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing cart: $e');
      }
    }
  }

  // ✅ Load cart from local storage
  Future<void> _loadCartFromStorage() async {
    try {
      final jsonString = _prefs.getString(_cartStorageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _items.clear();
        _items.addAll(
          jsonList.map((item) => SimpleCartItem.fromJson(item as Map<String, dynamic>))
        );
        if (kDebugMode) {
          print('✅ Loaded ${_items.length} items from local storage');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading cart from storage: $e');
      }
    }
  }

  // ✅ Save cart to local storage
  Future<void> _saveCartToStorage() async {
    try {
      final jsonList = _items.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(_cartStorageKey, jsonString);
      if (kDebugMode) {
        print('✅ Cart saved to local storage (${_items.length} items)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving cart to storage: $e');
      }
    }
  }

  // ✅ Sync cart with Firebase Database
  Future<void> _syncWithFirebase() async {
    try {
      if (_cartService.currentUserId == null) {
        if (kDebugMode) {
          print('ℹ️ No user logged in - skipping Firebase sync');
        }
        return;
      }

      _isSyncingWithFirebase = true;
      notifyListeners();

      // Try to load cart from Firebase
      final firebaseItems = await _cartService.loadCartFromFirebase();

      if (firebaseItems != null && firebaseItems.isNotEmpty) {
        // Firebase has cart data - use it
        _items.clear();
        _items.addAll(firebaseItems);
        await _saveCartToStorage();
        if (kDebugMode) {
          print('✅ Synced cart from Firebase (${_items.length} items)');
        }
      } else if (_items.isNotEmpty) {
        // Local has data but Firebase doesn't - sync to Firebase
        await _cartService.saveCartToFirebase(_items);
        if (kDebugMode) {
          print('✅ Synced local cart to Firebase');
        }
      }

      _isSyncingWithFirebase = false;
      notifyListeners();
    } catch (e) {
      _isSyncingWithFirebase = false;
      if (kDebugMode) {
        print('❌ Error syncing with Firebase: $e');
      }
    }
  }

  // ✅ Add item to cart (saves locally and to Firebase)
  void addToCart(SimpleProduct product) {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(SimpleCartItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        quantity: 1,
      ));
    }
    
    _saveCartToStorage();
    _saveCartToFirebase(); // Save to Firebase asynchronously
    notifyListeners();
  }

  // ✅ Remove item from cart (removes locally and from Firebase)
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCartToStorage();
    _cartService.removeItemFromCart(productId); // Remove from Firebase asynchronously
    notifyListeners();
  }

  // ✅ Clear entire cart (clears locally and from Firebase)
  void clearCart() {
    _items.clear();
    _saveCartToStorage();
    _cartService.clearCartFromFirebase(); // Clear from Firebase asynchronously
    notifyListeners();
  }

  // ✅ Update quantity (updates locally and in Firebase)
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      _saveCartToStorage();
      _cartService.updateItemQuantity(productId, quantity); // Update in Firebase asynchronously
      notifyListeners();
    }
  }

  // ✅ Save cart to Firebase
  Future<bool> _saveCartToFirebase() async {
    return await _cartService.saveCartToFirebase(_items);
  }

  // ✅ Manual sync with Firebase
  Future<void> syncWithFirebase() async {
    await _syncWithFirebase();
  }

  // ✅ Check if item is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  // ✅ Get cart item by product ID
  SimpleCartItem? getCartItem(String productId) {
    try {
      return _items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  // ✅ Get Firebase verification data
  Future<Map<String, dynamic>?> getFirebaseCartData() async {
    return await _cartService.getCartDetails();
  }
}
