import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_manager.dart';
import 'package:shopapp/screens/product_editing_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/product_management_list_tile.dart';

class ProductManagementScreen extends StatelessWidget {
  static const routeName = "/product-management-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(ProductEditingScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<ProductManager>(
        builder: (_, manager, __) {
          final products = manager.products;
          return RefreshIndicator(
            onRefresh: manager.fetchProducts,
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ProductManagementListTile(products[i]),
                    const Divider(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
