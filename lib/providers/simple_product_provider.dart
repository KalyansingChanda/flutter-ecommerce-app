import 'package:flutter/foundation.dart';

class SimpleProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final int discountPercent;

  SimpleProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    this.discountPercent = 0,
  });
}

class SimpleProductProvider with ChangeNotifier {
  final List<SimpleProduct> _products = [];

  List<SimpleProduct> get products => _products;

  SimpleProductProvider() {
    addSampleProducts();
  }

  void addSampleProducts() {
    _products.clear();
    _products.addAll([
      SimpleProduct(
        id: '1',
        name: 'Galaxy S22 Ultra',
        description: 'Samsung Galaxy S22 Ultra 5G',
        price: 32999.0,
        originalPrice: 74999.0,
        imageUrl: 'https://m.media-amazon.com/images/I/61cgGppG2ZL._AC_SX522_.jpg',
        category: 'Electronics',
        discountPercent: 56,
      ),
      SimpleProduct(
        id: '2',
        name: 'Galaxy M13 (4GB | 64 GB)',
        description: 'Samsung Galaxy M13 Android Smartphone',
        price: 10499.0,
        originalPrice: 14999.0,
        imageUrl: 'https://m.media-amazon.com/images/I/71Y2P1DSLdL._AC_SX522_.jpg',
        category: 'Electronics',
        discountPercent: 56,
      ),
      SimpleProduct(
        id: '3',
        name: 'Galaxy M33 (4GB | 64 GB)',
        description: 'Samsung Galaxy M33 5G Smartphone',
        price: 16999.0,
        originalPrice: 24999.0,
        imageUrl: 'https://m.media-amazon.com/images/I/71vBQpYHuWL._AC_SX522_.jpg',
        category: 'Electronics',
        discountPercent: 56,
      ),
      SimpleProduct(
        id: '4',
        name: 'Galaxy M53 (4GB | 64 GB)',
        description: 'Samsung Galaxy M53 5G Smartphone',
        price: 31999.0,
        originalPrice: 40999.0,
        imageUrl: 'https://m.media-amazon.com/images/I/61nzB9CQFNL._AC_SX522_.jpg',
        category: 'Electronics',
        discountPercent: 56,
      ),
      SimpleProduct(
        id: '5',
        name: 'Galaxy S22 Ultra',
        description: 'Samsung Galaxy S22 Ultra 5G Phantom Green',
        price: 67999.0,
        originalPrice: 86999.0,
        imageUrl: 'https://m.media-amazon.com/images/I/61F-mFacPdL._AC_SX522_.jpg',
        category: 'Electronics',
        discountPercent: 56,
      ),
    ]);
    notifyListeners();
  }
}