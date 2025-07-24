import '../../auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/orders_controller.dart';
import '../widgets/order_tile.dart';
 
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.orders.isEmpty
              ? const Center(child: Text('Nenhum pedido encontrado'))
              : ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return OrderTile(order: order);
                  },
                ),
    );
  }
}
