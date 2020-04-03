import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItemListTile extends StatelessWidget {
  final CartItem item;

  CartItemListTile(this.item);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).errorColor,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) cart.remove(item.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Chip(
              label: Text(
                "\$${item.price.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
            ),
            title: Text(item.title),
            subtitle: Text("Total: \$${item.price * item.quantity}"),
            trailing: Text("${item.quantity}x"),
          ),
        ),
      ),
    );
  }
}
