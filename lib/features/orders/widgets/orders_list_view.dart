import 'package:flutter/material.dart';
// imports removidos: provider, orders_controller (não utilizados)
import '../models/order_model.dart';

class OrdersListView extends StatelessWidget {
  final List<OrderModel> orders;
  final bool isLoading;
  final bool showAppBar;
  final VoidCallback? onBack;

  const OrdersListView({
    super.key,
    required this.orders,
    required this.isLoading,
    this.showAppBar = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return const Center(child: Text('Nenhum pedido encontrado'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final total = order.total.toStringAsFixed(2);
        final numeroPedido = order.id;
        final dataPtBr = order.date.toLocal().toString().split(' ')[0];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pedido: $numeroPedido', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Data: $dataPtBr'),
                  ],
                ),
                const SizedBox(height: 4),
                ...order.items.map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: item.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                            )
                          : const Icon(Icons.image_not_supported, size: 40),
                      title: Text(item.name),
                      subtitle: Text('Qtd: ${item.quantity} | R\$ ${item.price.toStringAsFixed(2)}'),
                    )),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Total: R\$ $total', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
