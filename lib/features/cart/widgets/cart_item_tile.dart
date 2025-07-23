import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../../../shared/utils/app_utils.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onRemove;

  const CartItemTile({super.key, required this.item, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(item.image, width: 48, height: 48, fit: BoxFit.cover),
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Text('Qtd: ${item.quantity}', style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 12),
            Text(formatCurrency(item.price), style: const TextStyle(fontSize: 13)),
          ],
        ),
        trailing: onRemove != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Remover',
                onPressed: onRemove,
              )
            : null,
      ),
    );
  }
}
