import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ✅ Stream-based product loading for real-time updates
  Stream<List<Product>> get productsStream => _productService.getProducts();

  void addSampleProducts() {
    _products = [
      Product(
        id: '1',
        name: 'Smartphone',
        description: 'Latest Android smartphone with amazing features',
        price: 15999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Phone',
        category: 'Electronics',
        createdAt: DateTime.now(),
      ),
      Product(
        id: '2',
        name: 'Laptop',
        description: 'High performance laptop for work and gaming',
        price: 45999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Laptop',
        category: 'Electronics',
        createdAt: DateTime.now(),
      ),
      Product(
        id: '3',
        name: 'T-Shirt',
        description: 'Comfortable cotton t-shirt in various colors',
        price: 599.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=T-Shirt',
        category: 'Clothing',
        createdAt: DateTime.now(),
      ),
      Product(
        id: '4',
        name: 'Headphones',
        description: 'Wireless Bluetooth headphones with noise cancellation',
        price: 2999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Headphones',
        category: 'Electronics',
        createdAt: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productService.getAllProducts();
    } catch (e) {
      _errorMessage = 'Failed to load products: ${e.toString()}';
      if (kDebugMode) {
        print('Error loading products: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ New Firebase-compatible add product method
  Future<bool> addProductWithImage({
    required String name,
    required double price,
    required String description,
    required File imageFile,
    String category = 'General',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _productService.addProduct(
        name: name,
        price: price,
        description: description,
        imageFile: imageFile,
        category: category,
      );
      
      // Reload products to get the latest data
      await loadProducts();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error adding product: $e');
      }
      return false;
    }
  }

  // ✅ Legacy method for backward compatibility
  Future<bool> addProduct(Product product) async {
    try {
      await _productService.updateProduct(product); // Use update since product has ID
      _products.add(product);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: ${e.toString()}';
      notifyListeners();
      if (kDebugMode) {
        print('Error adding product: $e');
      }
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _productService.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error updating product: $e');
      }
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _productService.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error deleting product: $e');
      }
      return false;
    }
  }

  // ✅ Enhanced search with Firebase support
  Future<List<Product>> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        return _products;
      }
      
      // Use Firebase search for better results
      final searchResults = await _productService.searchProducts(query);
      return searchResults;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching products: $e');
      }
      // Fallback to local search
      return _products.where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  // ✅ Enhanced category filtering with stream support
  Stream<List<Product>> getProductsByCategoryStream(String category) {
    return _productService.getProductsByCategory(category);
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  // ✅ Get single product
  Future<Product?> getProduct(String productId) async {
    try {
      return await _productService.getProduct(productId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting product: $e');
      }
      return null;
    }
  }

  // ✅ Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ Refresh products manually
  Future<void> refresh() async {
    await loadProducts();
  }
}