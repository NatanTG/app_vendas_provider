/// Modelo de item do carrinho
class CartItemModel {
  final int productId;
  int quantity;
  final double price;
  final String name;
  final String imageUrl;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.name,
    required this.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
