import 'package:flutter/foundation.dart';
import '../models/order.dart' as app_order;
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<app_order.Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<app_order.Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderService.getUserOrders(userId);
    } catch (e) {
      _errorMessage = 'Failed to load orders: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> placeOrder(app_order.Order order) async {
    try {
      await _orderService.createOrder(order);
      _orders.insert(0, order); // Add to beginning of list
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to place order: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, app_order.OrderStatus status) async {
    try {
      await _orderService.updateOrderStatus(orderId, status);
      
      // Update local list
      final index = _orders.indexWhere((order) => order.orderId == orderId);
      if (index != -1) {
        _orders[index] = app_order.Order(
          orderId: _orders[index].orderId,
          userId: _orders[index].userId,
          items: _orders[index].items,
          totalAmount: _orders[index].totalAmount,
          address: _orders[index].address,
          status: status,
          timestamp: _orders[index].timestamp,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update order status: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}