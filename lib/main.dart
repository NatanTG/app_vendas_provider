import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/app_theme.dart';
import 'features/auth/pages/login_page.dart';
import 'features/products/pages/products_page.dart';
import 'features/cart/pages/cart_page.dart';
import 'features/orders/pages/orders_page.dart';
import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Registrar dependências do GetIt
  setupDependencies();
  runApp(const VendasApp());
}

class VendasApp extends StatelessWidget {
  const VendasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendas App',
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/products': (context) => const ProductsPage(),
        '/cart': (context) => const CartPage(),
        '/orders': (context) => const OrdersPage(),
      },
    );
  }
}
