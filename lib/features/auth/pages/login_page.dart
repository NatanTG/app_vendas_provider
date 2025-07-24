
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  bool _navigated = false;

  void _handleAuthChange(AuthController controller) {
    if (!_navigated && controller.user != null) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/products');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
      });
    } else if (controller.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.error!),),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, controller, _) {
        _handleAuthChange(controller);
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: LoginForm(
                onLogin: (email, password) => controller.signIn(email, password),
                onSignUp: (email, password) => controller.signUp(email, password),
                isLoading: controller.isLoading,
                error: controller.error,
              ),
            ),
          ),
        );
      },
    );
  }
}
