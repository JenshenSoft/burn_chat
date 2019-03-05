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
  var _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.amber,
            accentColor: Colors.amberAccent,
            buttonColor: Colors.red),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => ScopedModelDescendant<MainModel>(
                  builder: (context, widget, model) {
                return model.user == null ? AuthPage() : ProductsPage(_model);
              }),
          '/products': (BuildContext context) => ProductsPage(_model),
          '/admin': (BuildContext context) => ProductsAdminPage(_model),
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
                _model.allProducts.firstWhere((p) => p.id == productId);
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
