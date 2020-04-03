import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';

class ProductManager with ChangeNotifier {
  List<Product> _products = Product.getData();

  List<Product> get products => [..._products];

  List<Product> get favourites => _products.where((p) => p.isFavorite).toList();

  Product findById(String id) => _products.firstWhere((p) => p.id == id);

  void onFavouriteChange() => notifyListeners();

  void remove(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
