import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/orders_controller.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final OrdersController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OrdersController();
    _controller.addListener(_onOrdersChanged);
    // Busca o userId do usuário logado
    final userId = _getUserId();
    if (userId != null) {
      _controller.fetchOrders(userId);
    }
  }

  String? _getUserId() {
    // Importa o AuthController e retorna o userId
    // Adapte conforme sua implementação
    try {
      // Se estiver usando AuthController global, pode acessar direto
      // Exemplo:
      // return AuthController().user?.uid;
      // Ou, se estiver usando FirebaseAuth direto:
      // return FirebaseAuth.instance.currentUser?.uid;
      // Aqui, para evitar dependência circular, use FirebaseAuth:
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onOrdersChanged);
    super.dispose();
  }

  void _onOrdersChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')), 
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.orders.isEmpty
              ? const Center(child: Text('Nenhum pedido encontrado'))
              : ListView.builder(
                  itemCount: _controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = _controller.orders[index];
                    return ExpansionTile(
                      title: Text('Pedido: ${order.id}'),
                      subtitle: Text('Total: R\$ ${order.total.toStringAsFixed(2)}'),
                      trailing: Text('${order.date.day}/${order.date.month}/${order.date.year}'),
                      children: order.items.map((item) => ListTile(
                        leading: Image.network(item.image, width: 32, height: 32, fit: BoxFit.cover),
                        title: Text(item.title),
                        subtitle: Text('Qtd: ${item.quantity} | R\$ ${item.price.toStringAsFixed(2)}'),
                      )).toList(),
                    );
                  },
                ),
    );
  }
}
