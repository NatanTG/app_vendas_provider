import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CartController extends ChangeNotifier {
  final List<CartItemModel> _items;

  List<CartItemModel> get items => List.unmodifiable(_items);

  double get total => _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  CartController({List<CartItemModel>? initialItems}) : _items = initialItems ?? [];


  void addItem(CartItemModel item) {
    final index = _items.indexWhere((i) => i.productId == item.productId);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void incrementItem(int productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementItem(int productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0 && _items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    } else if (index >= 0 && _items[index].quantity == 1) {
      removeItem(productId);
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((i) => i.productId == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
