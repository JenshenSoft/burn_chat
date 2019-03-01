import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProducts extends Model {
  List<Product> products = [];
  int selProductIndex;
  User authenticatedUser;

  void addProduct(
      {@required String title,
      @required String description,
      @required String image,
      @required double price}) {
    final Product newProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: authenticatedUser.name,
        userId: authenticatedUser.id);
    products.add(newProduct);
    selProductIndex = null;
    notifyListeners();
  }
}
