import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

/// Serviço para buscar produtos da API REST
class ProductsService {
  final String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar produtos');
    }
  }
}
