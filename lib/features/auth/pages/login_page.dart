
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AuthController();
    _controller.addListener(_onAuthChanged);
    _controller.loadCurrentUser();
  }

  @override
  void dispose() {
    _controller.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (_controller.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/products');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
      });
    } else if (_controller.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.error!),),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LoginForm(
            onLogin: (email, password) => _controller.signIn(email, password),
            onSignUp: (email, password) => _controller.signUp(email, password),
            isLoading: _controller.isLoading,
            error: _controller.error,
          ),
        ),
      ),
    );
  }
}
