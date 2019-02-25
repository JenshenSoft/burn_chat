import 'package:flutter/material.dart';

import './address_tag.dart';
import './product_tag.dart';
import '../ui_elements/title_default.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;

  const ProductCard(this.product, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleDefault(product['title']),
                SizedBox(width: 8),
                PriceTag(product['price'].toString()),
              ],
            ),
          ),
          AddressTag('Ukraine, Kharkiv'),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                            context, '/product/' + index.toString())
                        .then((bool value) {
                      /*if (value) {
                        deleteProduct(index);
                      }*/
                    }),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.yellow,
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
