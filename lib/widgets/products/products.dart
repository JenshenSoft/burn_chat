import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  final List<Product> products;

  Products(this.products);

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    if (products.length > 0) {
      return ListView.builder(
        itemBuilder: (context, index) => ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      return Container(); //Center(child: Text('No products found'));
    }
  }
}
