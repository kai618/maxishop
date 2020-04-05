import 'package:flutter/material.dart';

class ProductEditingScreen extends StatefulWidget {
  static const routeName = "/product-editing";

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

  @override
  void initState() {
    _imageUrlFocusNode.addListener(onFocusChange);

    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(onFocusChange);
    _imageUrlController.dispose();

    super.dispose();
  }

  void onFocusChange() {
    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  void saveInput() {
    final form = _formKey.currentState;
    if (!form.validate()) return;
    form.save();
    print(_input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Editing"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveInput();
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: "Title"),
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
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) => _input.price = double.parse(value),
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
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description"),
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
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
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
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
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
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
                          onSaved: (value) => _input.imageUrl = value,
                          validator: (value) {
                            return (value.isEmpty) ? "Please provide a URL." : null;
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
  double price = 0;
  String imageUrl = "";
  bool isFavorite = false;
}
