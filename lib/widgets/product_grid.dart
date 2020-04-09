import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/providers/product_manager.dart';
import 'package:shopapp/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final ViewFilter filter;

  ProductGrid(this.filter);

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<ProductManager>(context);
    final products = (filter == ViewFilter.All) ? manager.products : manager.favourites;

    return RefreshIndicator(
      onRefresh: manager.fetchProducts,
      color: Theme.of(context).primaryColor,
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
