import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

/// Serviço de pedidos integrado ao Firestore
class OrdersService {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');

  Future<List<OrderModel>> fetchOrders(String userId) async {
    final query = await _ordersCollection.where('userId', isEqualTo: userId).orderBy('date', descending: true).get();
    return query.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
  }

  Future<void> addOrder(OrderModel order) async {
    await _ordersCollection.add(order.toJson());
  }
}
