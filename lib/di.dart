import 'package:get_it/get_it.dart';
import 'features/products/controllers/products_controller.dart';
import 'features/products/services/products_service.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/orders/controllers/orders_controller.dart';
import 'features/orders/services/orders_service.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/services/auth_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services: stateless, podem ser singletons
  getIt.registerLazySingleton<ProductsService>(() => ProductsService());
  getIt.registerLazySingleton<OrdersService>(() => OrdersService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Controllers: mantêm estado, singletons
  getIt.registerLazySingleton<ProductsController>(() => ProductsController(service: getIt<ProductsService>()));
  getIt.registerLazySingleton<CartController>(() => CartController());
  getIt.registerLazySingleton<OrdersController>(() => OrdersController(service: getIt<OrdersService>()));
  getIt.registerLazySingleton<AuthController>(() => AuthController());
}
