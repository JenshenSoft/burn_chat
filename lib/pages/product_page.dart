import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  ProductPage({this.title, this.description, this.imageUrl, this.price});

  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

  Widget _buildAddress() {
    return Text('Ukraine, Kharkiv',
        style: TextStyle(fontFamily: 'Oswald', color: Colors.grey));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Product details"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(imageUrl),
              Container(
                padding: EdgeInsets.all(10),
                child: TitleDefault(title),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildAddress(),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text('|',
                          style: TextStyle(
                              fontFamily: 'Oswald', color: Colors.grey))),
                  Text('\$' + price.toString(),
                      style:
                          TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(description, textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}
