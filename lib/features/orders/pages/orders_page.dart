import 'package:provider_impl_app/shared/widgets/app_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final userId = _getUserId();
    if (userId != null) {
        Provider.of<OrdersController>(context, listen: false).fetchOrders(userId);
    }
    });
  }

  String? _getUserId() {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrdersController>();
    return AppScaffold(
      title: 'Pedidos',
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
