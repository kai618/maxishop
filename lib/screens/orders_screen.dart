import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders_manager.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item_list_tile.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders-screen";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<void> _fetchOrders(BuildContext context) {
    return Provider.of<OrderManager>(context, listen: false).fetch().catchError((error) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1500),
          content: const Text('Something went wrong'),
          backgroundColor: Colors.red[700],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Orders")),
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () => _fetchOrders(context),
            child: FutureBuilder(
              future: _fetchOrders(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(color: Theme.of(context).primaryColor);
                } else {
                  if (snapshot.error != null) {
                    return Center(child: Text('An error occured!'));
                  } else {
                    return Consumer<OrderManager>(
                      builder: (context, orderMgr, child) {
                        return orderMgr.orders.isEmpty
                            ? ListView(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "You have no orders.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: orderMgr.orders.length,
                                itemBuilder: (_, i) {
                                  return OrderItemListTile(orderMgr.orders[i]);
                                },
                              );
                      },
                    );
                  }
                }
              },
            ),
          );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
