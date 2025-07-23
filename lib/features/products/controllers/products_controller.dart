
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/products_service.dart';

/// ProductsController
/// Responsável por gerenciar o estado da lista de produtos.
/// - Busca produtos da API REST
/// - Expõe estado de loading e erro
/// - Pode ser testado independentemente da UI
class ProductsController extends ChangeNotifier {
  final ProductsService _service;
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  /// Permite injetar um service customizado para facilitar testes
  ProductsController({ProductsService? service}) : _service = service ?? ProductsService();

  /// Lista de produtos disponíveis
  List<ProductModel> get products => _products;
  /// Estado de carregamento
  bool get isLoading => _isLoading;
  /// Mensagem de erro, se houver
  String? get error => _error;

  /// Busca produtos da API REST
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
