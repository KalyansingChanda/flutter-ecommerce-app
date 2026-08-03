import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ✅ ADD PRODUCT API
  Future<String> addProduct({
    required String name,
    required double price,
    required String description,
    required File imageFile,
    String category = 'General',
  }) async {
    try {
      // 1. Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('products/$fileName.jpg');
      await ref.putFile(imageFile);
      String imageUrl = await ref.getDownloadURL();

      // 2. Save product data to Firestore
      DocumentReference docRef = await _firestore.collection('products').add({
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'category': category,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      print('✅ Product added successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error adding product: $e');
      throw Exception('Failed to add product: $e');
    }
  }

  // ✅ GET PRODUCTS API (Real-time stream)
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  // ✅ GET PRODUCTS API (Future-based for compatibility)
  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ Error getting products: $e');
      throw Exception('Failed to get products: $e');
    }
  }

  // ✅ GET SINGLE PRODUCT API
  Future<Product?> getProduct(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();
      
      if (doc.exists) {
        return Product.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ Error getting product: $e');
      throw Exception('Failed to get product: $e');
    }
  }

  // ✅ UPDATE PRODUCT API
  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toFirestore());
      
      print('✅ Product updated successfully: ${product.id}');
    } catch (e) {
      print('❌ Error updating product: $e');
      throw Exception('Failed to update product: $e');
    }
  }

  // ✅ DELETE PRODUCT API
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .delete();
      
      print('✅ Product deleted successfully: $productId');
    } catch (e) {
      print('❌ Error deleting product: $e');
      throw Exception('Failed to delete product: $e');
    }
  }

  // ✅ SEARCH PRODUCTS API
  Future<List<Product>> searchProducts(String query) async {
    try {
      // Simple search by name (case-insensitive)
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();
      
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ Error searching products: $e');
      throw Exception('Failed to search products: $e');
    }
  }

  // ✅ GET PRODUCTS BY CATEGORY API
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }
}