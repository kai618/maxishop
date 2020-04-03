import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_details_screen.dart';
import 'package:shopapp/providers/product_manager.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
          },
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavorite();
              Provider.of<ProductManager>(context, listen: false).onFavouriteChange();
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.add(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                duration: const Duration(milliseconds: 1000),
                backgroundColor: Theme.of(context).primaryColor,
                content: Text(
                  "${product.title} added.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                action: SnackBarAction(
                  label: "UNDO",
                  textColor: Colors.white,
                  onPressed: () {
                    cart.decrementItem(product.id);
                  },
                ),
              ));
            },
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
