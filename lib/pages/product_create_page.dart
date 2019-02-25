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

  Widget _buildTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product title'),
      autocorrect: true,
      onChanged: (value) {
        this._title = value;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      autocorrect: true,
      decoration: InputDecoration(labelText: 'Product description'),
      maxLines: 4,
      onChanged: (value) {
        this._description = value;
      },
    );
  }

  Widget _buildPriceField() {
    return TextField(
      autocorrect: true,
      decoration: InputDecoration(labelText: 'Product price'),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        this._price = double.parse(value);
      },
    );
  }

  void _submitFrom() {
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
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
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
    );
  }
}
