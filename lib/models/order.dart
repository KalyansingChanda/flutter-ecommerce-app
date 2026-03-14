import 'product.dart';

enum OrderStatus {
  placed,    // 0 - Order Placed
  packed,    // 1 - Order Packed  
  shipped,   // 2 - Order Shipped
  outForDelivery, // 3 - Out for Delivery
  delivered, // 4 - Delivered
}

class Order {
  final String orderId;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String address;
  final OrderStatus status;
  final DateTime timestamp;

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.status,
    required this.timestamp,
  });

  factory Order.fromMap(Map<String, dynamic> map, String orderId) {
    return Order(
      orderId: orderId,
      userId: map['userId'] ?? '',
      items: (map['items'] as List)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      status: OrderStatus.values[map['status'] ?? 0],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'address': address,
      'status': status.index,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 1,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}