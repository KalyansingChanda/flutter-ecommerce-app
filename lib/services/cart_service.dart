import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/simple_cart_provider.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _cartCollectionName = 'carts';

  // ✅ GET CURRENT USER ID
  String? get currentUserId => _auth.currentUser?.uid;

  // ✅ SAVE CART TO FIRESTORE
  Future<bool> saveCartToFirebase(List<SimpleCartItem> items) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ No user logged in');
        return false;
      }

      // Convert items to JSON
      final cartData = {
        'userId': userId,
        'items': items.map((item) => {
          'productId': item.productId,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
        }).toList(),
        'totalAmount': items.fold<double>(0, (sum, item) => sum + item.totalPrice),
        'itemCount': items.fold<int>(0, (sum, item) => sum + item.quantity),
        'lastUpdated': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await _firestore
          .collection(_cartCollectionName)
          .doc(userId)
          .set(cartData, SetOptions(merge: true));

      print('✅ Cart saved to Firebase successfully');
      return true;
    } catch (e) {
      print('❌ Error saving cart to Firebase: $e');
      return false;
    }
  }

  // ✅ LOAD CART FROM FIRESTORE
  Future<List<SimpleCartItem>?> loadCartFromFirebase() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ No user logged in');
        return null;
      }

      final doc = await _firestore
          .collection(_cartCollectionName)
          .doc(userId)
          .get();

      if (!doc.exists) {
        print('ℹ️ No cart found in Firebase for user');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      final itemsList = data['items'] as List<dynamic>? ?? [];

      final items = itemsList.map((item) {
        final itemData = item as Map<String, dynamic>;
        return SimpleCartItem(
          productId: itemData['productId'] as String,
          name: itemData['name'] as String,
          price: (itemData['price'] as num).toDouble(),
          quantity: itemData['quantity'] as int,
        );
      }).toList();

      print('✅ Cart loaded from Firebase (${items.length} items)');
      return items;
    } catch (e) {
      print('❌ Error loading cart from Firebase: $e');
      return null;
    }
  }

  // ✅ ADD ITEM TO CART IN FIREBASE (Real-time)
  Future<bool> addItemToCart({
    required String productId,
    required String name,
    required double price,
    int quantity = 1,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ No user logged in');
        return false;
      }

      // Use transaction for atomicity
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection(_cartCollectionName).doc(userId);
        final doc = await transaction.get(docRef);

        if (doc.exists) {
          final items = doc['items'] as List<dynamic>;
          final existingIndex = items.indexWhere(
            (item) => item['productId'] == productId,
          );

          if (existingIndex != -1) {
            items[existingIndex]['quantity'] += quantity;
          } else {
            items.add({
              'productId': productId,
              'name': name,
              'price': price,
              'quantity': quantity,
            });
          }

          transaction.update(docRef, {
            'items': items,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(docRef, {
            'userId': userId,
            'items': [{
              'productId': productId,
              'name': name,
              'price': price,
              'quantity': quantity,
            }],
            'lastUpdated': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      });

      print('✅ Item added to Firebase cart');
      return true;
    } catch (e) {
      print('❌ Error adding item to Firebase cart: $e');
      return false;
    }
  }

  // ✅ REMOVE ITEM FROM FIREBASE CART
  Future<bool> removeItemFromCart(String productId) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ No user logged in');
        return false;
      }

      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection(_cartCollectionName).doc(userId);
        final doc = await transaction.get(docRef);

        if (doc.exists) {
          final items = doc['items'] as List<dynamic>;
          items.removeWhere((item) => item['productId'] == productId);

          transaction.update(docRef, {
            'items': items,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });

      print('✅ Item removed from Firebase cart');
      return true;
    } catch (e) {
      print('❌ Error removing item from Firebase cart: $e');
      return false;
    }
  }

  // ✅ UPDATE ITEM QUANTITY IN FIREBASE
  Future<bool> updateItemQuantity(String productId, int quantity) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ No user logged in');
        return false;
      }

      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection(_cartCollectionName).doc(userId);
        final doc = await transaction.get(docRef);

        if (doc.exists) {
          final items = doc['items'] as List<dynamic>;
          final itemIndex = items.indexWhere((item) => item['productId'] == productId);

          if (itemIndex != -1) {
            if (quantity > 0) {
              items[itemIndex]['quantity'] = quantity;
            } else {
              items.removeAt(itemIndex);
            }

            transaction.update(docRef, {
              'items': items,
              'lastUpdated': FieldValue.serverTimestamp(),
            });
          }
        }
      });

      print('✅ Item quantity updated in Firebase cart');
      return true;
    } catch (e) {
      print('❌ Error updating item quantity in Firebase cart: $e');
      return false;
    }
  }

  // ✅ CLEAR ENTIRE CART IN FIREBASE
  Future<bool> clearCartFromFirebase() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ No user logged in');
        return false;
      }

      await _firestore.collection(_cartCollectionName).doc(userId).delete();
      print('✅ Cart cleared from Firebase');
      return true;
    } catch (e) {
      print('❌ Error clearing cart from Firebase: $e');
      return false;
    }
  }

  // ✅ GET CART DETAILS (For verification/debugging)
  Future<Map<String, dynamic>?> getCartDetails() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ No user logged in');
        return null;
      }

      final doc = await _firestore
          .collection(_cartCollectionName)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      print('❌ Error getting cart details: $e');
      return null;
    }
  }

  // ✅ STREAM CART UPDATES (Real-time listening)
  Stream<List<SimpleCartItem>?> cartStream() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection(_cartCollectionName)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      final itemsList = data['items'] as List<dynamic>? ?? [];

      return itemsList.map((item) {
        final itemData = item as Map<String, dynamic>;
        return SimpleCartItem(
          productId: itemData['productId'] as String,
          name: itemData['name'] as String,
          price: (itemData['price'] as num).toDouble(),
          quantity: itemData['quantity'] as int,
        );
      }).toList();
    });
  }
}
