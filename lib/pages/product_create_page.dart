import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;
  final Function deleteProduct;

  const ProductCreatePage(this.addProduct, this.deleteProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _title = '';
  String _description;
  double _price;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product title'),
      autocorrect: true,
      validator: (value) {
        if (value.trim().isEmpty || value.length > 5) {
          return 'Titile is required and should be 5+ characters long';
        }
      },
      onSaved: (value) {
        this._title = value;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      autocorrect: true,
      decoration: InputDecoration(labelText: 'Product description'),
      maxLines: 4,
      validator: (value) {
        if (value.trim().isEmpty || value.length > 10) {
          return 'Description is required and should be 10+ characters long';
        }
      },
      onSaved: (value) {
        this._description = value;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      autocorrect: true,
      decoration: InputDecoration(labelText: 'Product price'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.trim().isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
          return 'Price is required and should be number';
        }
      },
      onSaved: (value) {
        this._price = double.parse(value);
      },
    );
  }

  void _submitFrom() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final Map<String, dynamic> product = {
      'title': _title,
      'description': _description,
      'price': _price,
      'image': 'assets/food.jpg',
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Container(
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
    );
  }
}
