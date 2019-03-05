import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

const url = 'https://burn-chat-99efa.firebaseio.com/products';
const imageUrl =
    'http://mikemoir.com/mikemoir/wp-content/uploads/2015/06/MedRes_Product-presentation-2.jpg';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Null> addProduct(
      {@required String title,
      @required String description,
      @required String image,
      @required double price}) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.name,
      'userId': _authenticatedUser.id,
      'image': imageUrl,
    };
    return http
        .post(url + ".json", body: json.encode(data))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.name,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
    });
  }
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

  Future<Null> updateProduct(
      {@required String title,
      @required String description,
      @required String image,
      @required double price}) {
    _isLoading = true;
    notifyListeners();
    final Product newProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: _authenticatedUser.name,
        userId: _authenticatedUser.id);
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.name,
      'userId': _authenticatedUser.id,
      'image': imageUrl,
    };

    String newUrl = url + "/${selectedProduct.id}.json";
    print(newUrl);
    return http
        .put(newUrl, body: json.encode(data))
        .then((http.Response response) {
      _products[selectedProductIndex] = newProduct;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> deleteProduct() {
    _isLoading = true;
    var id = selectedProduct.id;
    int selectedProductIndex =
        _products.indexWhere((product) => product.id == _selProductId);
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    String newUrl = url + "/$id.json";
    return http.delete(newUrl).then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
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

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get(url + ".json").then((response) {
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
          ));
        });
        _products = products;
      }
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    });
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProducts {
  void login(String email, String password) {
    _authenticatedUser = User(id: "cdskmcds", name: email, password: password);
  }
}

mixin LCEModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
