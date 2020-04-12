import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double totalCost;
  final List<CartItem> items;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.totalCost,
    @required this.items,
    @required this.dateTime,
  });
}

class OrderManager with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> fetch() async {
    try {
      const url = 'https://maxi-eshop.firebaseio.com/orders.json';
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        _orders.clear();
        return;
      }

      _orders.clear();
      data.forEach((key, value) {
        final items = value['items'] as List<dynamic>;
        _orders.add(Order(
          id: key,
          totalCost: value['totalCost'],
          dateTime: DateTime.parse(value['dateTime']),
          items: items
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList(),
        ));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> add(List<CartItem> items, double totalCost) async {
    final timestamp = DateTime.now();
    try {
      const url = 'https://maxi-eshop.firebaseio.com/orders.json';
      final response = await http.post(url,
          body: json.encode({
            'totalCost': totalCost,
            'items': items
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'price': item.price,
                      'quantity': item.quantity,
                    })
                .toList(),
            'dateTime': timestamp.toIso8601String(),
          }));

      _orders.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          totalCost: totalCost,
          items: items,
          dateTime: timestamp,
        ),
      );
    } catch (error) {
      throw error;
    }
  }
}
