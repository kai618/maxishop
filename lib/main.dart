import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_details_screen.dart';
import 'package:shopapp/screens/product_management_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_manager.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductManager()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: MaterialApp(
        title: 'Maxishop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrangeAccent,
          fontFamily: 'Lato',
        ),
        initialRoute: ProductManagementScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
          ProductDetailsScreen.routeName: (_) => ProductDetailsScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
          ProductManagementScreen.routeName: (_) => ProductManagementScreen(),
        },
      ),
    );
  }
}
