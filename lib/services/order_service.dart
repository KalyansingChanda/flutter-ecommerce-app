import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as app_order;
import '../utils/constants.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createOrder(app_order.Order order) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.ordersCollection)
          .add(order.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('ऑर्डर तयार करण्यात अयशस्वी: $e');
    }
  }

  Future<List<app_order.Order>> getUserOrders(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => app_order.Order.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('वापरकर्त्याचे ऑर्डर मिळविण्यात अयशस्वी: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, app_order.OrderStatus status) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({'status': status.index});
    } catch (e) {
      throw Exception('ऑर्डर स्टेटस अपडेट करण्यात अयशस्वी: $e');
    }
  }
}
