import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/pages/login_page.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/orders/controllers/orders_controller.dart';
import 'features/orders/pages/orders_list_page.dart';
import 'features/products/controllers/products_controller.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<ProductsController>()),
        ChangeNotifierProvider(create: (_) => getIt<CartController>()),
        ChangeNotifierProvider(create: (_) => getIt<OrdersController>()),
        ChangeNotifierProvider(create: (_) => getIt<AuthController>()),
      ],
      child: MaterialApp(
        title: 'Vendas App',
        theme: AppTheme.lightTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/products': (context) => const ProductsPage(),
          '/cart': (context) => const CartPage(),
          '/orders': (context) => const OrdersPage(),
          '/orders-list': (context) => const OrdersListPage(),
        },
      ),
    );
  }
}