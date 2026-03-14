import '../models/product.dart';
import '../utils/constants.dart';

class ProductService {
  // Mock service for non-Firebase version

  Future<List<Product>> getAllProducts() async {
    try {
      // Mock implementation - return empty list for now
      await Future.delayed(const Duration(milliseconds: 500));
      return <Product>[];
    } catch (e) {
      throw Exception('उत्पादने मिळविण्यात अयशस्वी: $e');
    }
  }

  Future<Product?> getProduct(String productId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    } catch (e) {
      throw Exception('उत्पादन मिळविण्यात अयशस्वी: $e');
    }
  }

  Future<String> addProduct(Product product) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.productsCollection)
          .add(product.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('उत्पादन जोडण्यात अयशस्वी: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      throw Exception('उत्पादन अपडेट करण्यात अयशस्वी: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('उत्पादन हटविण्यात अयशस्वी: $e');
    }
  }

  Stream<List<Product>> getProductsStream() {
    return _firestore
        .collection(AppConstants.productsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('श्रेणीनुसार उत्पादने मिळविण्यात अयशस्वी: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a simple implementation using where clause
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('उत्पादने शोधण्यात अयशस्वी: $e');
    }
  }
}