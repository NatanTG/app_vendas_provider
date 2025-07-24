import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/orders_service.dart';

/// Controller de pedidos
class OrdersController extends ChangeNotifier {
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
    await fetchOrders(order.userId);
  }
}
