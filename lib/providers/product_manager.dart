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

  void add(String title, String description, String imageUrl, double price) {
    _products.insert(
      0,
      Product(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        imageUrl: imageUrl,
        price: price,
      ),
    );
    notifyListeners();
  }

  void update(
    String id,
    String title,
    String description,
    String imageUrl,
    double price,
  ) {
    final index = _products.indexWhere((p) => p.id == id);
    _products[index] = Product(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );
    notifyListeners();
  }
}
