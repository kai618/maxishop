import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cart_item_list_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Total', style: TextStyle(fontSize: 20)),
                  Chip(
                    label: Text(
                      "\$${cart.totalCost.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 2,
                  ),
                  OutlineButton(
                    highlightElevation: 4,
                    child: const Text("ORDER NOW"),
                    onPressed: () {
                      if (cart.items.isNotEmpty) {
                        final orders = Provider.of<Orders>(context, listen: false);
                        orders.add(cart.items.values.toList(), cart.totalCost);
                        cart.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, i) {
                return CartItemListTile(cart.items.values.toList()[i]);
              },
            ),
          )
        ],
      ),
    );
  }
}
