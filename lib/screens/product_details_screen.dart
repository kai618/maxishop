import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_manager.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product-details";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductManager>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(),
      body: Image.network(product.imageUrl),
    );
  }
}
