import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import '../../auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/orders_service.dart';

/// Controller de pedidos
class OrdersController extends ChangeNotifier {

  /// Busca os pedidos do usuário autenticado usando o AuthController do contexto.
  Future<void> loadUserOrders(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final userId = authController.user?.uid;
    debugPrint('[OrdersController] userId encontrado: $userId');
    if (userId != null && userId.isNotEmpty) {
      await fetchOrders(userId);
    } else {
      debugPrint('[OrdersController] userId não encontrado ou vazio.');
    }
  }
  final OrdersService _service;
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  OrdersController({OrdersService? service}) : _service = service ?? OrdersService();

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

Future<void> fetchOrders(String userId) async {
  _isLoading = true;
  _error = null;
  notifyListeners();
  try {
    _orders = await _service.fetchOrders(userId);
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  /// Adiciona um novo pedido. Lança uma exceção amigável se o userId estiver vazio ou nulo.
  Future<void> addOrder(OrderModel order) async {
    if (order.userId.trim().isEmpty) {
      throw Exception('Usuário não autenticado. Faça login novamente para finalizar a compra.');
    }
    await _service.addOrder(order);
    // Pequeno delay para garantir que o Firestore indexe o novo pedido
    await Future.delayed(const Duration(milliseconds: 400));
    await fetchOrders(order.userId);
  }
}
