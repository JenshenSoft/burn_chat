import 'package:flutter/material.dart';

import './models/product.dart';
import './pages/auth_page.dart';
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
  List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.amber,
          accentColor: Colors.amberAccent,
          buttonColor: Colors.red),
      //home: AuthPage(),
      routes: {
        '/': (context) => AuthPage(),
        '/products': (context) => ProductsPage(_products),
        '/admin': (context) => ProductsAdminPage(
            _addProducts, _updateProduct, _deleteProduct, _products),
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
                    title: _products[index].title,
                    description: _products[index].description,
                    imageUrl: _products[index].image,
                    price: _products[index].price,
                  ));
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => ProductsPage(_products));
      },
    );
  }

  void _addProducts(Product product) {
    setState(() {
      _products.add(product);
      print(_products);
    });
  }

  void _updateProduct(int index, Product product) {
    setState(() {
      _products[index] = product;
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
