import 'product.dart';

class CartItem {
  final String productId;
  final Product product;
  int quantity;

  CartItem({
    required this.productId,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, Product product) {
    return CartItem(
      productId: map['productId'] ?? '',
      product: product,
      quantity: map['quantity'] ?? 1,
    );
  }
}