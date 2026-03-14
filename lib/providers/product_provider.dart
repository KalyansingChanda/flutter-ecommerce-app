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
      _errorMessage = 'उत्पादने लोड करण्यात अयशस्वी: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addProduct(Product product) async {
    try {
      await _productService.addProduct(product);
      _products.add(product);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'उत्पादन जोडण्यात अयशस्वी: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await _productService.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'उत्पादन अपडेट करण्यात अयशस्वी: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'उत्पादन हटविण्यात अयशस्वी: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  List<Product> searchProducts(String query) {
    return _products.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }
}