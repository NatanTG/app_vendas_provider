import 'package:flutter/material.dart';

/// Widget utilitário para mostrar SnackBar padronizado
void showAppSnackBar(BuildContext context, String message, {bool success = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.red,
      duration: const Duration(seconds: 2),
    ),
  );
}
