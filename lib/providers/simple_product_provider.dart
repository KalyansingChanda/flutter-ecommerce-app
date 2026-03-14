import 'package:flutter/foundation.dart';

class SimpleProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  SimpleProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class SimpleProductProvider with ChangeNotifier {
  final List<SimpleProduct> _products = [];

  List<SimpleProduct> get products => _products;

  void addSampleProducts() {
    _products.clear();
    _products.addAll([
      SimpleProduct(
        id: '1',
        name: 'Smartphone',
        description: 'Latest Android smartphone with amazing features',
        price: 15999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Phone',
        category: 'Electronics',
      ),
      SimpleProduct(
        id: '2',
        name: 'Laptop',
        description: 'High performance laptop for work and gaming',
        price: 45999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Laptop',
        category: 'Electronics',
      ),
      SimpleProduct(
        id: '3',
        name: 'T-Shirt',
        description: 'Comfortable cotton t-shirt in various colors',
        price: 599.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=T-Shirt',
        category: 'Clothing',
      ),
      SimpleProduct(
        id: '4',
        name: 'Headphones',
        description: 'Wireless Bluetooth headphones with noise cancellation',
        price: 2999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Headphones',
        category: 'Electronics',
      ),
      SimpleProduct(
        id: '5',
        name: 'Watch',
        description: 'Smart watch with fitness tracking',
        price: 8999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Watch',
        category: 'Electronics',
      ),
      SimpleProduct(
        id: '6',
        name: 'Shoes',
        description: 'Comfortable running shoes',
        price: 1999.0,
        imageUrl: 'https://via.placeholder.com/300x300?text=Shoes',
        category: 'Footwear',
      ),
    ]);
    notifyListeners();
  }
}