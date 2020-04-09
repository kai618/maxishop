import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_manager.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = "/loading";

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Provider.of<ProductManager>(context, listen: false).fetchProducts();
        Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName);
      } catch (error) {
        _buildDialog(error.toString());
      }
    });
    super.initState();
  }

  Future _buildDialog(String err) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("An error occurred"),
          content: Text(err.toString()),
          actions: <Widget>[
            OutlineButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitCircle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
