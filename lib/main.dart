import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './data/models/product.dart';
import './data/scoped-models/main.dart';
import './pages/auth_page.dart';
import './pages/product_page.dart';
import './pages/products_admin_page.dart';
import './pages/products_page.dart';
// import 'package:flutter/rendering.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(BurnChatApp());
}

class BurnChatApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BurnChatAppState();
  }
}

class _BurnChatAppState extends State<BurnChatApp> {
  @override
  Widget build(BuildContext context) {
    var mainModel = MainModel();
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.amber,
            accentColor: Colors.amberAccent,
            buttonColor: Colors.red),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(mainModel),
          '/admin': (BuildContext context) => ProductsAdminPage(mainModel),
        },
        // link: /product/21
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                mainModel.allProducts.firstWhere((p) => p.id == productId);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(null));
        },
      ),
    );
  }
}
