import 'dart:async';

import 'package:flutter/material.dart';

import '../data/models/product.dart';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final Product _product;

  ProductPage(this._product);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print('Back button pressed!');
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_product.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(_product.image),
                height: 300,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/food.jpg'),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(_product.title),
              ),
              _buildAddressPriceRow(_product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  _product.description,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
