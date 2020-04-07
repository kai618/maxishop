import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final product = Product(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );

    const url = "https://maxi-eshop.firebaseio.com/products";
    http.post(url, body: json.encode(product.toJson()));

    _products.insert(0, product);
    notifyListeners();
  }

  void update(
    String id,
    String title,
    String description,
    String imageUrl,
    double price,
  ) {
    final product = Product(
      id: id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );

    const url = "https://maxi-eshop.firebaseio.com/products.json";
    http.post(url, body: json.encode(product.toJson()));

    final index = _products.indexWhere((p) => p.id == id);
    _products[index] = product;
    notifyListeners();
  }
}
