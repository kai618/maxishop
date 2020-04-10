import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double totalCost;
  final List<CartItem> items;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.totalCost,
    @required this.items,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

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
        OrderItem(
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
