import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Web cart item with local persistence
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

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
  };

  factory SimpleCartItem.fromJson(Map<String, dynamic> json) {
    return SimpleCartItem(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}

/// Web-compatible cart provider with SharedPreferences persistence
class SimpleCartProvider with ChangeNotifier {
  final List<SimpleCartItem> _items = [];
  bool _isSyncing = false;
  bool _isInitialized = false;

  List<SimpleCartItem> get items => _items;
  bool get isSyncing => _isSyncing;
  bool get isInitialized => _isInitialized;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  static const String _storageKey = 'ecommerce_cart_items';

  /// Initialize cart from local storage
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_storageKey);
      
      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> items = json.decode(cartJson);
        _items.clear();
        for (var item in items) {
          _items.add(SimpleCartItem.fromJson(item));
        }
        print('✅ Cart loaded from storage: ${_items.length} items');
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading cart: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Save cart to local storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString(_storageKey, cartJson);
      print('✅ Cart saved to storage: ${_items.length} items');
    } catch (e) {
      print('❌ Error saving cart: $e');
    }
  }

  /// Add item to cart
  void addToCart(String productId, String name, double price) {
    final existingIndex = _items.indexWhere((item) => item.productId == productId);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(SimpleCartItem(
        productId: productId,
        name: name,
        price: price,
        quantity: 1,
      ));
    }
    
    _saveToStorage();
    notifyListeners();
  }

  /// Remove item from cart
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveToStorage();
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => SimpleCartItem(productId: '', name: '', price: 0, quantity: 0),
    );
    if (item.productId.isNotEmpty) {
      item.quantity = newQuantity;
      _saveToStorage();
      notifyListeners();
    }
  }

  /// Clear cart
  void clearCart() {
    _items.clear();
    _saveToStorage();
    notifyListeners();
  }
}
