import 'package:flutter/material.dart';

import './pages/auth_route.dart';
import './pages/product_page.dart';
import './pages/products_admin_page.dart';
import './pages/products_page.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugPaintPointersEnabled = true;
  runApp(BurnChatApp());
}

class BurnChatApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BurnChatAppState();
  }
}

class _BurnChatAppState extends State<BurnChatApp> {
  List<Map<String, dynamic>> _products = [];

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
        '/': (context) => AuthPage(),
        '/products': (context) => ProductsPage(_products),
        '/admin': (context) => ProductsAdminPage(_addProducts, _deleteProduct),
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
                    description: _products[index]['description'],
                    imageUrl: _products[index]['image'],
                    price: _products[index]['price'],
                  ));
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => ProductsPage(_products));
      },
    );
  }

  void _addProducts(Map<String, dynamic> product) {
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
