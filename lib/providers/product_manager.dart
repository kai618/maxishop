import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductManager with ChangeNotifier {
  String _token;

  set token(String val) => _token = val;

  List<Product> _products = [];

  List<Product> get products => [..._products];

  List<Product> get favourites => _products.where((p) => p.isFavorite).toList();

  Product findById(String id) => _products.firstWhere((p) => p.id == id);

  void onFavouriteChange() => notifyListeners();

  Future<void> remove(String id) async {
    final index = _products.indexWhere((p) => p.id == id);
    final target = _products[index];
    _products.removeAt(index);
    notifyListeners();

    try {
//      final url = "https://maxi-eshop.firebaseio.com/products/$id.json";
      final url = "https://maxi-eshop.firebaseio.com/products/$id"; // wrong url
      final response = await http.delete(url);
      if (response.statusCode >= 400) throw HttpException("Something went wrong");
    } catch (error) {
      _products.insert(index, target);
      notifyListeners();
      throw (error);
    }
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

  Future<void> update(String id, String title, String description, String imageUrl, double price) async {
    final product = Product(
      id: id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );

    final url = "https://maxi-eshop.firebaseio.com/products/$id.json";

    try {
      await http.patch(url, body: json.encode(product.toJson()));
    } catch (err) {
      throw err;
    }

    final index = _products.indexWhere((p) => p.id == id);
    _products[index] = product;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final url = "https://maxi-eshop.firebaseio.com/products.json?auth=$_token";
    try {
      final response = await http.get(url);
      final products = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) throw HttpException(json.decode(response.body)['error']);

      _products.clear();
      products.forEach((key, value) {
        _products.add(Product(
          id: key,
          title: value["title"],
          imageUrl: value["imageUrl"],
          description: value["description"],
          price: value["price"],
          isFavorite: value["isFavorite"],
        ));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
