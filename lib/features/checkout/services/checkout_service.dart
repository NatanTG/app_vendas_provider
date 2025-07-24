import 'package:cloud_firestore/cloud_firestore.dart';
import '../../cart/models/cart_item_model.dart';

class CheckoutService {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');

  Future<void> saveTransaction({
    required List<CartItemModel> items,
    required double total,
    required String userId,
  }) async {
    // Gera um id único para o pedido
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    await _ordersCollection.add({
      'id': orderId,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'date': DateTime.now().toIso8601String(),
    });
  }
}
