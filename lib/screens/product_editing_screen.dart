import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_manager.dart';

enum Mode { Update, Add }

class ProductEditingScreen extends StatefulWidget {
  static const routeName = "/product-editing";
  final Mode mode;

  ProductEditingScreen({this.mode = Mode.Add});

  @override
  _ProductEditingScreenState createState() => _ProductEditingScreenState();
}

class _ProductEditingScreenState extends State<ProductEditingScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _input = ProductInput();
  var isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(onFocusChange);

    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(onFocusChange);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void onFocusChange() {
    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  void saveProduct() {
    final form = _formKey.currentState;
    if (!form.validate()) return;
    form.save();
    setState(() => isLoading = true);

    final manager = Provider.of<ProductManager>(context, listen: false);
    switch (widget.mode) {
      case Mode.Update:
        manager
            .update(_input.id, _input.title, _input.description, _input.imageUrl,
                double.parse(_input.price))
            .catchError((err) => _buildDialog(err.toString()))
            .whenComplete(popOut);
        break;
      case Mode.Add:
        manager
            .add(_input.title, _input.description, _input.imageUrl, double.parse(_input.price))
            .catchError((err) => _buildDialog(err.toString()))
            .whenComplete(popOut);
        break;
    }
  }

  void popOut() {
    setState(() => isLoading = false);
    Navigator.of(context).pop();
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
    if (widget.mode == Mode.Update) {
      final id = ModalRoute.of(context).settings.arguments as String;
      final product = Provider.of<ProductManager>(context, listen: false).findById(id);
      _input.id = product.id;
      _input.title = product.title;
      _input.price = product.price.toString();
      _input.description = product.description;
      _imageUrlController.text = product.imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Editing"),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.save), onPressed: this.saveProduct),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Title"),
                        initialValue: _input.title,
                        textInputAction: TextInputAction.next,
                        // the bottom right key of the soft keyboard
                        onFieldSubmitted: (_) {
                          // when user presses the bottom right key
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) => _input.title = value,
                        validator: (value) {
                          return (value.isEmpty) ? "Please provide a title." : null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Price"),
                        initialValue: _input.price,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) => _input.price = value,
                        validator: (val) {
                          if (val.isEmpty)
                            return "Please provide a number.";
                          else if (double.tryParse(val) == null)
                            return "Invalid number.";
                          else
                            return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Description"),
                        initialValue: _input.description,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_priceFocusNode),
                        onSaved: (value) => _input.description = value,
                        validator: (value) {
                          return (value.isEmpty) ? "Please provide a description." : null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration:
                                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text("Enter a URL"))
                                : Image.network(_imageUrlController.text, fit: BoxFit.contain),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 16),
                                cursorColor: Colors.green,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green)),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.blue[50],
                                  prefixIcon: const Icon(Icons.image),
                                ),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                onSaved: (val) => _input.imageUrl = val,
                                validator: (val) {
                                  if (val.isEmpty) return "Please provide a URL.";
                                  if (!val.startsWith("http://") && !val.startsWith("https://"))
                                    return "Invalid URL";
                                  return null;
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class ProductInput {
  String id;
  String title = "";
  String description = "";
  String price = "";
  String imageUrl = "";
}
