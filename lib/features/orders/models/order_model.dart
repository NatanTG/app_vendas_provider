import '../../cart/models/cart_item_model.dart';

/// Modelo de pedido
class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double total;
  final DateTime date;
  final String userId;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.userId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }
}
