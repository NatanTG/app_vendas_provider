import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  late final ProductsController _controller;
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    // Usando get_it para injeção de dependência
    _controller = getIt<ProductsController>();
    _controller.addListener(_onProductsChanged);
    _controller.fetchProducts();
  }

  @override
  void dispose() {
    _controller.removeListener(_onProductsChanged);
    super.dispose();
  }

  void _onProductsChanged() => setState(() {});

  int get cartCount {
    final cartController = getIt<CartController>();
    return cartController.items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? Center(child: Text(_controller.error!))
              : ListView.builder(
                  itemCount: _controller.products.length,
                  itemBuilder: (context, index) {
                    final product = _controller.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        final cartController = getIt<CartController>();
                        cartController.addItem(
                          CartItemModel(
                            productId: product.id,
                            title: product.title,
                            price: product.price,
                            image: product.image,
                          ),
                        );
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.title} adicionado ao carrinho!')),
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
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}