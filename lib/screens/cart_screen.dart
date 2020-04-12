import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders_manager.dart';
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
                  const SizedBox(width: 30),
                  Chip(
                    label: Text(
                      "\$${cart.totalCost.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 2,
                  ),
                  const Spacer(),
                  OrderButton(cart),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (_, i) => CartItemListTile(cart.items.values.toList()[i]),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton(this.cart);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.items;

    return OutlineButton(
      highlightElevation: 4,
      child: _isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            )
          : const Text("ORDER NOW"),
      onPressed: (items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() => _isLoading = true);
              try {
                final orders = Provider.of<OrderManager>(context, listen: false);
                await orders.add(items.values.toList(), widget.cart.totalCost);
                widget.cart.clear();
              } catch (error) {
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 1500),
                    content: const Text('Something went wrong'),
                    backgroundColor: Colors.red[700],
                  ),
                );
              } finally {
                setState(() => _isLoading = false);
              }
            },
    );
  }
}
