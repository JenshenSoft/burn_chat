import '../models/user.dart';
import '../scoped-models/connected_products.dart';

mixin UserModel on ConnectedProducts {
  void login(String email, String password) {
    authenticatedUser = User(id: "cdskmcds", name: email, password: password);
  }
}
