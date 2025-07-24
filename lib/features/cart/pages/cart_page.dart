import 'package:flutter/material.dart';

import '../../orders/controllers/orders_controller.dart';
import '../../orders/models/order_model.dart';
import '../controllers/cart_controller.dart';
import 'package:provider/provider.dart';
import '../../auth/controllers/auth_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Garante que o usuário está carregado ao entrar na tela
    final authController = context.read<AuthController>();
    authController.loadCurrentUser();
  }
  bool _isProcessing = false;
  String? _error;
  late CartController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<CartController>();
  }

  @override
  void dispose() {
    _controller.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final authController = context.read<AuthController>();
    final orderController = context.read<OrdersController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: cartController.items.isEmpty
          ? const Center(child: Text('Seu carrinho está vazio'))
          : ListView.builder(
              itemCount: cartController.items.length,
              itemBuilder: (context, index) {
                final item = cartController.items[index];
                return ListTile(
                  leading: Image.network(
                    item.image,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.title),
                  subtitle: Text(
                    'Qtd: ${item.quantity} | R\$ ${item.price.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            cartController.decrementItem(item.productId),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            cartController.incrementItem(item.productId),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            cartController.removeItem(item.productId),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cartController.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: R\$ ${cartController.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () async {
                            if (mounted) {
                              setState(() {
                                _isProcessing = true;
                                _error = null;
                              });
                            }
                            try {
                              final userId = authController.user?.uid ?? '';
                              final order = OrderModel(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                items: cartController.items,
                                total: cartController.total,
                                date: DateTime.now(),
                                userId: userId,
                              );
                              await orderController.addOrder(order);
                              cartController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Compra finalizada!'),
                                ),
                              );
                              Navigator.pushNamed(context, '/orders');
                            } catch (e) {
                              if (mounted) {
                                setState(() {
                                  _error = 'Erro ao finalizar compra: $e';
                                });
                              }
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(_error!)));
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isProcessing = false;
                                });
                              }
                            }
                          },
                    child: _isProcessing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Finalizar'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
