import '../../cart/models/cart_item_model.dart';
import '../services/checkout_service.dart';

class CheckoutController {
  final CheckoutService _service;

  CheckoutController({CheckoutService? service}) : _service = service ?? CheckoutService();

  Future<void> saveTransaction({
    required List<CartItemModel> items,
    required double total,
    required String userId,
  }) async {
    await _service.saveTransaction(items: items, total: total, userId: userId);
  }
}
