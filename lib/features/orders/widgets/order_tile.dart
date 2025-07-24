import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Pedido: ${order.id}'),
      subtitle: Text('Total: R\$ ${order.total.toStringAsFixed(2)}'),
      children: order.items.map((item) => ListTile(
        title: Text(item.name),
        subtitle: Text('Qtd: ${item.quantity} | R\$ ${item.price.toStringAsFixed(2)}'),
      )).toList(),
    );
  }
}
