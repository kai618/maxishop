import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';

class ProductManagementListTile extends StatelessWidget {
  final Product product;

  ProductManagementListTile(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
