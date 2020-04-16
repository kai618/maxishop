import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders_manager.dart';
import 'package:shopapp/providers/product_manager.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/loading_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_details_screen.dart';
import 'package:shopapp/screens/product_editing_screen.dart';
import 'package:shopapp/screens/product_management_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ProxyProvider<Auth, ProductManager>(
          update: (_, auth, productMgr) => productMgr..token = auth.token ?? ProductManager(),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => OrderManager()),
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) {
          return MaterialApp(
            title: 'Maxishop',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.greenAccent,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              LoadingScreen.routeName: (_) => LoadingScreen(),
              ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
              ProductDetailsScreen.routeName: (_) => ProductDetailsScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrdersScreen.routeName: (_) => OrdersScreen(),
              ProductManagementScreen.routeName: (_) => ProductManagementScreen(),
              ProductEditingScreen.routeName: (_) => ProductEditingScreen(),
              AuthScreen.routeName: (_) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
