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

  Future<void> add(String title, String description, String imageUrl, double price) async {
    const url = "https://maxi-eshop.firebaseio.com/products.json";
    final res = await http.post(url,
        body: json.encode({
          "title": title,
          "description": description,
          "price": price,
          "imageUrl": imageUrl,
          "isFavorite": false,
        }));

    final product = Product(
      id: json.decode(res.body)["name"],
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );

    _products.insert(0, product);
    notifyListeners();
  }

  Future<void> update(
    String id,
    String title,
    String description,
    String imageUrl,
    double price,
  ) async {
    final product = Product(
      id: id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );

    final url = "https://maxi-eshop.firebaseio.com/products/$id.json";

    try {
      await http.put(url, body: json.encode(product.toJson()));
    } catch (err) {
      throw err;
    }

    final index = _products.indexWhere((p) => p.id == id);
    _products[index] = product;
    notifyListeners();
  }
}
