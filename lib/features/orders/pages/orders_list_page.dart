import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/orders_controller.dart';
import '../widgets/orders_list_view.dart';

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
      context.read<OrdersController>().loadUserOrders(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrdersController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/products', (route) => false),
          tooltip: 'Voltar para produtos',
        ),
      ),
      body: OrdersListView(
        orders: controller.orders,
        isLoading: controller.isLoading,
      ),
    );
  }
}
