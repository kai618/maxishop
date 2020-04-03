import 'package:flutter/foundation.dart';
import 'package:shopapp/providers/cart.dart';

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

  void add(List<CartItem> items, double totalCost) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          totalCost: totalCost,
          items: items,
          dateTime: DateTime.now()),
    );

  }


}
