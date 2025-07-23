
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/products_service.dart';


class ProductsController extends ChangeNotifier {
  final ProductsService _service;
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  ProductsController({ProductsService? service}) : _service = service ?? ProductsService();

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
