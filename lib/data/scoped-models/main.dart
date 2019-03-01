import '../scoped-models/connected_products.dart';
import '../scoped-models/products.dart';
import '../scoped-models/scoped_user.dart';

class MainModel extends ConnectedProducts with UserModel, ProductsModel {}
