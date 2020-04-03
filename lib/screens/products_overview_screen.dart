import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/product_grid.dart';

enum ViewFilter { Fav, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = "/product-overview";

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var viewFilter = ViewFilter.All;

  void onChangeViewFilter(ViewFilter filter) {
    if (viewFilter != filter)
      setState(() {
        viewFilter = filter;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop App"),
        actions: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              Positioned(
                top: 8,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  padding: const EdgeInsets.all(5),
                  child: Consumer<Cart>(
                    builder: (context, cart, _) {
                      return Text(cart.productCount.toString(), style: TextStyle(fontSize: 11));
                    },
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton(
            onSelected: (filter) => this.onChangeViewFilter(filter),
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem(child: Text("Show Favourites"), value: ViewFilter.Fav, height: 40),
                PopupMenuItem(child: Text("Show All"), value: ViewFilter.All, height: 40),
              ];
            },
          ),
        ],
      ),
      body: ProductGrid(viewFilter),
      drawer: AppDrawer(),
    );
  }
}
