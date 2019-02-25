import 'package:flutter/material.dart';

import './product_create_page.dart';
import './product_list_page.dart';

class ProductsAdminPage extends StatelessWidget {
  final Function addProducts;
  final Function deleteProducts;

  ProductsAdminPage(this.addProducts, this.deleteProducts);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
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
        ),
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
          ProductCreatePage(addProducts, deleteProducts),
          ProductListPage(),
        ]),
      ),
    );
  }
}
