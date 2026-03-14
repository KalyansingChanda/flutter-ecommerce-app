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
      throw Exception('Failed to get products: $e');
    }
  }

  Future<Product?> getProduct(String productId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  Future<String> addProduct(Product product) async {
    try {
      // Mock implementation - return a fake ID
      await Future.delayed(const Duration(milliseconds: 500));
      return 'mock_product_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Stream<List<Product>> getProductsStream() {
    // Mock implementation - return empty stream
    return Stream.value(<Product>[]);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      // Mock implementation - return empty list
      await Future.delayed(const Duration(milliseconds: 500));
      return <Product>[];
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      // Mock implementation - return empty list
      await Future.delayed(const Duration(milliseconds: 500));
      return <Product>[];
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}