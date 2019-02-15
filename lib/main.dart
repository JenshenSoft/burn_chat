import 'package:flutter/material.dart';

import './pages/product_route.dart';
import './pages/products_admin_page.dart';
import './pages/products_page.dart';

void main() {
  /*debugPaintBaselinesEnabled = true;
  debugPaintSizeEnabled = true;
  debugPaintPointersEnabled = true;*/
  runApp(BurnChatApp());
}

class BurnChatApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BurnChatAppState();
  }
}

class _BurnChatAppState extends State<BurnChatApp> {
  List<Map<String, String>> _products = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepPurple),
      //home: AuthPage(),
      routes: {
        '/': (context) => ProductsPage(_products, _addProducts, _deleteProduct),
        '/admin': (context) => ProductsAdminPage(),
      },
      // link: /product/21
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[0] != 'product') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
              builder: (context) => ProductPage(
                    title: _products[index]['title'],
                    imageUrl: _products[index]['image'],
                  ));
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (context) =>
                ProductsPage(_products, _addProducts, _deleteProduct));
      },
    );
  }

  void _addProducts(Map<String, String> product) {
    setState(() {
      _products.add(product);
      print(_products);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
      print(_products);
    });
  }
}
