import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id, // this is the date when this item is created
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {}; // key is the id of the product

  Map<String, CartItem> get items => {...?_items};

  int get productCount {
    int amount = 0;
    _items.values.forEach((item) => amount += item.quantity);
    return amount;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalCost {
    double amount = 0.0;
    _items.values.forEach((item) => amount += item.price * item.quantity);
    return amount;
  }

  void add(String productId, double price, String title) {
    _items.update(
      productId,
      (i) => CartItem(
        id: i.id,
        title: i.title,
        quantity: i.quantity + 1,
        price: i.price,
      ),
      ifAbsent: () => _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      ),
    );
    notifyListeners();
  }

  void remove(String itemId) {
    _items.removeWhere((_, item) => item.id == itemId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void decrementItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (i) => CartItem(
          id: i.id,
          title: i.title,
          quantity: i.quantity - 1,
          price: i.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
