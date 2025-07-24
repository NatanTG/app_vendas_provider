import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../auth/controllers/auth_controller.dart';

import '../../checkout/controllers/checkout_controller.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final authController = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumo da compra', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartController.items.length,
                itemBuilder: (context, index) {
                  final item = cartController.items[index];
                  return ListTile(
                    leading: Image.network(item.image, width: 40, height: 40, fit: BoxFit.cover),
                    title: Text(item.title),
                    subtitle: Text('Qtd: ${item.quantity} | R\$ ${item.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Total: R\$ ${cartController.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cartController.items.isEmpty ? null : () async {
                  final userId = authController.user?.uid;
                  if (userId == null || userId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuário não autenticado!')),
                    );
                    return;
                  }
                  final checkoutController = CheckoutController();
                  try {
                    await checkoutController.saveTransaction(
                      items: cartController.items,
                      total: cartController.total,
                      userId: userId,
                    );
                    cartController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compra finalizada!')),
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao finalizar compra: $e')),
                    );
                  }
                },
                child: const Text('Finalizar compra'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
