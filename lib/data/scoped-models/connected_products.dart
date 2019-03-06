import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth.dart';
import '../models/product.dart';
import '../models/user.dart';

const url = 'https://burn-chat-99efa.firebaseio.com/products';
const auth = ".json?auth=";
const imageUrl =
    'http://mikemoir.com/mikemoir/wp-content/uploads/2015/06/MedRes_Product-presentation-2.jpg';

const KEY = 'AIzaSyDjp1_evJWQXf_qdfjuiqUtktFV-Exjuu4';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;
}

mixin ProductsModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (_selProductId == null) {
      return null;
    }
    return _products.firstWhere((product) {
      return product.id == _selProductId;
    });
  }

  int get selectedProductIndex {
    return _products.indexWhere((product) => product.id == _selProductId);
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addProduct(
      {@required String title,
      @required String description,
      @required String image,
      @required double price}) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'image': imageUrl,
    };
    try {
      final http.Response response = await http
          .post(url + auth + _authenticatedUser.token, body: json.encode(data));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      {@required String title,
      @required String description,
      @required String image,
      @required double price}) async {
    _isLoading = true;
    notifyListeners();
    final Product newProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'image': imageUrl,
    };

    String newUrl =
        url + "/${selectedProduct.id}" + auth + _authenticatedUser.token;
    print(newUrl);
    return http
        .put(newUrl, body: json.encode(data))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      _products[selectedProductIndex] = newProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() async {
    _isLoading = true;
    var id = selectedProduct.id;
    int selectedProductIndex =
        _products.indexWhere((product) => product.id == _selProductId);
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    String newUrl = url + "/$id" + auth + _authenticatedUser.token;
    return http.delete(newUrl).then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    var response;
    if (newFavoriteStatus) {
      response = await http.put(
          url +
              '/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}' +
              auth + _authenticatedUser.token,
          body: 'true');
    } else {
      response = await http.delete(url +
          '/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}' +
          auth + _authenticatedUser.token);
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      return;
    }
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  Future<bool> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    return http.get(url + auth + _authenticatedUser.token).then((response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Product> products = [];
      if (data != null) {
        data.forEach((id, data) {
          products.add(Product(
            id: id,
            title: data['title'],
            description: data['description'],
            image: data['image'],
            userId: data['userId'],
            userEmail: data['userEmail'],
            price: data['price'],
            isFavorite: data['data'] == null ? false : (data['data'] as Map<String, dynamic>)
                .containsKey(_authenticatedUser.id),
          ));
        });
        _products = products;
      }
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProducts {
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  User get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$KEY",
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$KEY",
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken'],
      );
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("id", _authenticatedUser.id);
      prefs.setString("email", _authenticatedUser.email);
      prefs.setString("token", _authenticatedUser.token);
      _userSubject.add(true);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    _userSubject.add(false);
  }
}

mixin LCEModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
