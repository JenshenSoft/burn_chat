import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list_page.dart';

class ProductsAdminPage extends StatelessWidget {
  final Function addProduct;
  final Function updateProduct;
  final Function deleteProduct;
  final List<Map<String, dynamic>> products;

  ProductsAdminPage(
      this.addProduct, this.updateProduct, this.deleteProduct, this.products);

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Choose'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: Text("Test"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Create product',
                icon: Icon(Icons.create),
              ),
              Tab(
                text: 'My products',
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          ProductEditPage(
              addProduct: addProduct, updateProduct: deleteProduct),
          ProductListPage(products, updateProduct, deleteProduct),
        ]),
      ),
    );
  }
}
