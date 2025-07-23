import 'package:flutter/material.dart';

import '../../orders/controllers/orders_controller.dart';
import '../../orders/models/order_model.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isProcessing = false;
  String? _error;
  late final CartController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CartController();
    _controller.addListener(_onCartChanged);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: _controller.items.isEmpty
          ? const Center(child: Text('Seu carrinho está vazio'))
          : ListView.builder(
              itemCount: _controller.items.length,
              itemBuilder: (context, index) {
                final item = _controller.items[index];
                return ListTile(
                  leading: Image.network(item.image, width: 48, height: 48, fit: BoxFit.cover),
                  title: Text(item.title),
                  subtitle: Text('Qtd: ${item.quantity} | R\$ ${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _controller.removeItem(item.productId.toString()),
                  ),
                );
              },
            ),
      bottomNavigationBar: _controller.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: R\$ ${_controller.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
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
                              final orderController = OrdersController();
                              final order = OrderModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                items: _controller.items,
                                total: _controller.total,
                                date: DateTime.now(),
                              );
                              await orderController.addOrder(order);
                              _controller.clear();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra finalizada!')));
                              Navigator.pushNamed(context, '/orders');
                            } catch (e) {
                              if (mounted) {
                                setState(() {
                                  _error = 'Erro ao finalizar compra: $e';
                                });
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_error!)),
                              );
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
