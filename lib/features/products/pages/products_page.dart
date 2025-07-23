import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/models/cart_item_model.dart';
import '../controllers/products_controller.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    // O ProductsController já está disponível via Provider
    Future.microtask(() {
      context.read<ProductsController>().fetchProducts();
    });
  }

  int get cartCount {
    final cartController = context.watch<CartController>();
    return cartController.items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    final productsController = context.watch<ProductsController>();
    final cartController = context.watch<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Tem certeza que deseja sair?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await context.read<AuthController>().signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: productsController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productsController.error != null
              ? Center(child: Text(productsController.error!))
              : ListView.builder(
                  itemCount: productsController.products.length,
                  itemBuilder: (context, index) {
                    final product = productsController.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        cartController.addItem(
                          CartItemModel(
                            productId: product.id,
                            title: product.title,
                            price: product.price,
                            image: product.image,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.title} adicionado ao carrinho!',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: Stack(
        alignment: Alignment.topRight,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            child: const Icon(Icons.shopping_cart),
          ),
          if (cartCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                child: Text(
                  '$cartCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
