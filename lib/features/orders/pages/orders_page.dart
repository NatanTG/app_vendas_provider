import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/orders_controller.dart';
import '../widgets/orders_list_view.dart';

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
      context.read<OrdersController>().loadUserOrders(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrdersController>();
    return Scaffold(
      body: OrdersListView(
        orders: controller.orders,
        isLoading: controller.isLoading,
      ),
    );
  }
}
