import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item_list_tile.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders-screen";

  @override
  Widget build(BuildContext context) {
    final orderList = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: ListView.builder(
        itemCount: orderList.orders.length,
        itemBuilder: (_, i) {
          return OrderItemListTile(orderList.orders[i]);
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
