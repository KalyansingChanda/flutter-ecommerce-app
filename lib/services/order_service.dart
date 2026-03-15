import '../models/order.dart' as app_order;

class OrderService {
  // Mock service for non-Firebase version

  Future<String> createOrder(app_order.Order order) async {
    try {
      // Mock implementation - return fake order ID
      await Future.delayed(const Duration(milliseconds: 500));
      return 'mock_order_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<app_order.Order>> getUserOrders(String userId) async {
    try {
      // Mock implementation - return empty list
      await Future.delayed(const Duration(milliseconds: 500));
      return <app_order.Order>[];
    } catch (e) {
      throw Exception('Failed to get user orders: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, app_order.OrderStatus status) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}
