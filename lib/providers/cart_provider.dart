import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_app/models/cart.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> cart = [];

  void add_item(CartItem item) {
    final index = cart.indexWhere((e) => e.name == item.name);
    if (index != -1) {
      cart[index].quantity += 1;
    } else {
      cart.add(item);
    }
    notifyListeners();
  }

  void remove_item(String name) {
    cart.removeWhere((item) => item.name == name);
    notifyListeners();
  }
}
