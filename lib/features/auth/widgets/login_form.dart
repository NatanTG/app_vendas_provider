import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onLogin;
  final void Function(String email, String password)? onSignUp;
  final bool isLoading;
  final String? error;

  const LoginForm({
    super.key,
    required this.onLogin,
    this.onSignUp,
    this.isLoading = false,
    this.error,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => _email = value,
            validator: (value) => value != null && value.contains('@') ? null : 'Email inválido',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Senha'),
            obscureText: true,
            onChanged: (value) => _password = value,
            validator: (value) => value != null && value.length >= 6 ? null : 'Mínimo 6 caracteres',
          ),
          if (widget.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(widget.error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onLogin(_email, _password);
                    }
                  },
            child: widget.isLoading ? const CircularProgressIndicator() : const Text('Entrar'),
          ),
          if (widget.onSignUp != null)
            TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onSignUp!(_email, _password);
                      }
                    },
              child: const Text('Criar conta'),
            ),
        ],
      ),
    );
  }
}
