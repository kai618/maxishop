import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/product_manager.dart';
import 'package:shopapp/screens/product_editing_screen.dart';

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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductEditingScreen(mode: Mode.Update),
                  settings: RouteSettings(arguments: product.id),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () {
              showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Product Removal", style: TextStyle(color: Colors.red)),
                      content: Text("Do you want to delete ${product.title}?"),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text("Yes"),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        FlatButton(
                          child: const Text("No"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ],
                    );
                  }).then((val) {
                if (val)
                  Provider.of<ProductManager>(context, listen: false)
                      .remove(product.id)
                      .catchError((error) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(error.toString(), textAlign: TextAlign.center),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: const Duration(milliseconds: 1500),
                    ));
                  });
              });
            },
          ),
        ],
      ),
    );
  }
}
