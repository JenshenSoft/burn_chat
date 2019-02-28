import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final int productIndex;
  final Map<String, dynamic> product;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title ': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product title'),
      autocorrect: true,
      initialValue: widget.product == null ? '' : widget.product['title'],
      validator: (value) {
        if (value.trim().isEmpty || value.length < 5) {
          return 'Titile is required and should be 5+ characters long';
        }
      },
      onSaved: (value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      autocorrect: true,
      decoration: InputDecoration(labelText: 'Product description'),
      maxLines: 4,
      initialValue: widget.product == null ? '' : widget.product['description'],
      validator: (value) {
        if (value.trim().isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long';
        }
      },
      onSaved: (value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      autocorrect: true,
      decoration: InputDecoration(labelText: 'Product price'),
      keyboardType: TextInputType.number,
      initialValue:
          widget.product == null ? '' : widget.product['price'].toString(),
      validator: (value) {
        if (value.trim().isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
          return 'Price is required and should be number';
        }
      },
      onSaved: (value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitFrom() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.product == null) {
      widget.addProduct(_formData);
    } else {
      widget.updateProduct(widget.productIndex, _formData);
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildGesture(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTextField(),
              _buildDescriptionField(),
              _buildPriceField(),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: _submitFrom,
              )
              //Text()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pageContent = _buildGesture(context);
    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit'),
            ),
            body: pageContent,
          );
  }
}
