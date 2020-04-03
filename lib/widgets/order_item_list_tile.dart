import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemListTile extends StatefulWidget {
  final OrderItem order;

  OrderItemListTile(this.order);

  @override
  _OrderItemListTileState createState() => _OrderItemListTileState();
}

class _OrderItemListTileState extends State<OrderItemListTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${widget.order.totalCost}"),
            subtitle: Text(DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded)
            Container(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              height: min(widget.order.items.length * 50.0 + 20, 300),
              child: ListView(
                children: <Widget>[
                  Divider(),
                  ...widget.order.items.map((i) {
                    return ListTile(
                      title: Text(i.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("${i.quantity}x   "),
                          Text(i.price.toString()),
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            )
        ],
      ),
    );
  }
}
