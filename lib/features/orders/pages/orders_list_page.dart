import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/orders_controller.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final controller = context.read<OrdersController>();
      controller.loadUserOrders(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrdersController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pedidos')),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.orders.isEmpty
              ? const Center(child: Text('Nenhum pedido encontrado'))
              : ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('Pedido: ${order.id}'),
                        subtitle: Text('Total: R\$ ${order.total.toStringAsFixed(2)}'),
                        trailing: Text(order.date.toString()),
                      ),
                    );
                  },
                ),
    );
  }
}
