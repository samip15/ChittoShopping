import 'dart:convert';
import 'dart:io';

import 'package:chito_shopping/provider/API.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  String imageUrl;
  final String description;
  final String rating;
  final double price;
  final String type;
  final String category;
  final String creatorId;
  bool isFavourite;
  Product(
      {@required this.id,
      this.creatorId,
      @required this.category,
      @required this.title,
      this.imageUrl,
      @required this.description,
      @required this.rating,
      @required this.price,
      @required this.type,
      this.isFavourite = false});
}

class Products with ChangeNotifier {
  final String _token;
  final String _userId;

  Products(this._token, this._userId);

  List<Product> _products = [
    // Product(
    //   category: "Clothing",
    //   id: "First",
    //   title: "Watch",
    //   price: 2000,
    //   description: "The best watch you will ever find.",
    //   imageUrl:
    //       "https://www.surfstitch.com/on/demandware.static/-/Sites-ss-master-catalog/default/dwef31ef54/images/MBB-M43BLK/BLACK-WOMENS-ACCESSORIES-ROSEFIELD-WATCHES-MBB-M43BLK_1.JPG",
    //   isFavourite: false,
    //   rating: "4.5",
    //   type: "Flash",
    // ),
    // Product(
    //     category: "Sports",
    //     id: "second",
    //     title: "Shoes",
    //     price: 1500,
    //     description: "Quality and comfort shoes with fashionable style.",
    //     imageUrl:
    //         "https://assets.adidas.com/images/w_600,f_auto,q_auto:sensitive,fl_lossy/e06ae7c7b4d14a16acb3a999005a8b6a_9366/Lite_Racer_RBN_Shoes_White_F36653_01_standard.jpg",
    //     isFavourite: false,
    //     rating: "4",
    //     type: "New"),
    // Product(
    //     category: "Electronics",
    //     id: "third",
    //     title: "Laptop",
    //     price: 80000,
    //     description: "The compact and powerful gaming laptop under the budget.",
    //     imageUrl:
    //         "https://d4kkpd69xt9l7.cloudfront.net/sys-master/images/h57/hdd/9010331451422/razer-blade-pro-hero-mobile.jpg",
    //     isFavourite: false,
    //     rating: "3.5",
    //     type: "New"),
    // Product(
    //     category: "Clothing",
    //     id: "four",
    //     title: "T-Shirt",
    //     price: 1000,
    //     description: "A red color tshirt you can wear at any occassion.",
    //     imageUrl:
    //         "https://5.imimg.com/data5/LM/NA/MY-49778818/mens-round-neck-t-shirt-500x500.jpg",
    //     isFavourite: false,
    //     rating: "3.5",
    //     type: "New"),
  ];
  // Get The Product List
  List<Product> get products {
    return [..._products];
  }

  // Get The flash sale Product List
  List<Product> get flashSaleProducts {
    return [..._products.where((prod) => prod.type == "Flash").toList()];
  }

  // Get The new sale Product List
  List<Product> get newProducts {
    return [..._products.where((prod) => prod.type == "New").toList()];
  }

  // Get The new sale Product List
  List<Product> getCategoryProducts(String category) {
    return [..._products.where((prod) => prod.category == category).toList()];
  }

  // Get The favourite Product List
  List<Product> get favProducts {
    return [..._products.where((prod) => prod.isFavourite).toList()];
  }

  // Get The favourite Product List
  List<Product> get userProducts {
    return [..._products.where((prod) => prod.creatorId == _userId).toList()];
  }

  // find product by id
  Product findProductById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  //toggle Favourites
  Future<void> toggleFavourite(String id) async {
    Product toggleProduct = _products.firstWhere((prod) => prod.id == id);
    final oldStatus = toggleProduct.isFavourite;
    toggleProduct.isFavourite = !toggleProduct.isFavourite;
    notifyListeners();
    // post data if any error reverse old status
    try {
      await http.put(
          API.toggleFavourite + "$_userId/$id.json" + "?auth=$_token",
          body: json.encode(toggleProduct.isFavourite));
    } catch (error) {
      toggleProduct.isFavourite = oldStatus;
      notifyListeners();
    }
  }

  // fetch all products from firebase
  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await http.get(API.products + "?auth=$_token");
      final allMap = json.decode(response.body) as Map<String, dynamic>;

      // fetch favourite api also
      final favouriteResponse = await http.get(
        API.toggleFavourite + "$_userId.json" + "?auth=$_token",
      );

      final favouriteData = json.decode(favouriteResponse.body);

      final List<Product> allProducts = [];
      allMap.forEach((prodId, prodData) {
        allProducts.add(
          Product(
            id: prodId,
            category: prodData['category'],
            title: prodData['title'],
            imageUrl: prodData['imageUrl'],
            description: prodData['description'],
            rating: prodData['rating'],
            price: double.parse(prodData['price'].toString()),
            type: prodData['type'],
            creatorId: prodData['creatorId'],
            isFavourite:
                favouriteData == null ? false : favouriteData[prodId] ?? false,
          ),
        );
      });
      _products = allProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // add product
  Future<void> addProduct(Product addProduct, File imageFile) async {
    // add to firebase
    try {
      final addMap = {
        "category": addProduct.category,
        "title": addProduct.title,
        "description": addProduct.description,
        "rating": addProduct.rating,
        "price": addProduct.price,
        "type": addProduct.type,
        "imageUrl": "",
        "creatorId": _userId,
      };
      if (imageFile != null) {
        addMap["imageUrl"] =
            await uploadProductPhoto(DateTime.now().toString(), imageFile);
        addProduct.imageUrl = addMap["imageUrl"];
      }
      final response = await http.post(
        API.products + "?auth=$_token",
        body: json.encode(addMap),
      );
      print(response.body);
      final id = json.decode(response.body);
      final newProduct = Product(
        id: id["name"],
        category: addProduct.category,
        title: addProduct.title,
        imageUrl: addProduct.imageUrl,
        description: addProduct.description,
        rating: addProduct.rating,
        price: addProduct.price,
        type: addProduct.type,
        creatorId: _userId,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // update product
  Future<void> updateProduct(
      String id, Product updatedProduct, File imageFile) async {
    // add to firebase
    try {
      final prodIndex = _products.indexWhere((prod) => prod.id == id);
      Map updatedMap = {
        "category": updatedProduct.category,
        "title": updatedProduct.title,
        "imageUrl": updatedProduct.imageUrl,
        "description": updatedProduct.description,
        "rating": updatedProduct.rating,
        "price": updatedProduct.price,
        "type": updatedProduct.type,
        "creatorId": _userId,
      };
      if (imageFile != null) {
        updatedMap["imageUrl"] = await uploadProductPhoto(id, imageFile);
        updatedProduct.imageUrl = updatedMap["imageUrl"];
      }
      final response = await http.patch(
        API.baseUrl + "/products/$id.json" + "?auth=$_token",
        body: json.encode(updatedMap),
      );
      print(response.body);
      _products[prodIndex] = updatedProduct;
      _products.add(updatedProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // delete product
  Future<void> deleteProduct(String productId) async {
    try {
      final prodIndex = _products.indexWhere((prod) => prod.id == productId);
      Product existingProduct = _products[prodIndex];
      // remove the product
      _products.removeAt(prodIndex);
      notifyListeners();
      final response = await http
          .delete(API.baseUrl + "/products/$productId.json" + "?auth=$_token");
      // if firebase could not delete
      if (response.statusCode >= 400) {
        _products.insert(prodIndex, existingProduct);
        throw HttpException("Could not be deleted! Try Again!");
        notifyListeners();
      } else {
        existingProduct = null;
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // upload product photo to firebase
  Future<String> uploadProductPhoto(String productId, File imageFile) async {
    try {
      String imageFileName = imageFile.path.split('/').last;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('products/$productId/$imageFileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      String imageUrl = await (await uploadTask).ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
