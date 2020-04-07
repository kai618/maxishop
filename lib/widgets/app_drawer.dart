import 'package:flutter/material.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_management_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text("Maxishop"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Shop", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Cart", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text("Management", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pushNamed(ProductManagementScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
