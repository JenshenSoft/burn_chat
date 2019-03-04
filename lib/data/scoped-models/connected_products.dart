import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

const url = 'https://burn-chat-99efa.firebaseio.com/products.json';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  int _selProductIndex;
  User _authenticatedUser;

  void addProduct(
      {@required String title,
      @required String description,
      @required String image,
      @required double price}) {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.name,
      'userId': _authenticatedUser.id,
      'image':
          'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjXjKeq7OjgAhXJlYsKHYhwDS0QjRx6BAgBEAU&url=http%3A%2F%2Fmikemoir.com%2Fmikemoir%2Fwhy-you-should-treat-your-content-like-a-product%2F&psig=AOvVaw2vByxoH88OTOcwSJ1-oafX&ust=1551801259887514',
    };
    http.post(url, body: json.encode(data)).then((http.Response response) {
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
      _selProductIndex = null;
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

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (_selProductIndex == null) {
      return null;
    }
    return _products[_selProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(
      {@required String title,
      @required String description,
      @required String image,
      @required double price}) {
    final Product newProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: _authenticatedUser.name,
        userId: _authenticatedUser.id);
    _products[_selProductIndex] = newProduct;
    _selProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selProductIndex);
    _selProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[_selProductIndex] = updatedProduct;
    _selProductIndex = null;
    notifyListeners();
  }

  void fetchProducts() {
    http.get(url).then((response) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Product> products = [];
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
      notifyListeners();
    });
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners();
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
