import 'dart:convert';

import 'package:chito_shopping/provider/API.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String rating;
  final double price;
  final String type;
  final String category;
  bool isFavourite;
  Product(
      {@required this.id,
      @required this.category,
      @required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.rating,
      @required this.price,
      @required this.type,
      this.isFavourite = false});
}

class Products with ChangeNotifier {
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

  // Get The favourite Product List
  List<Product> get favProducts {
    return [..._products.where((prod) => prod.isFavourite).toList()];
  }

  // find product by id
  Product findProductById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  //toggle Favourites
  void toggleFavourite(String id) {
    Product toggleProduct = _products.firstWhere((prod) => prod.id == id);
    toggleProduct.isFavourite = !toggleProduct.isFavourite;
    notifyListeners();
  }

  // fetch all products from firebase
  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await http.get(API.products);
      final allMap = json.decode(response.body) as Map<String, dynamic>;
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
  Future<void> addProduct(Product product) async {
    // add to firebase
    try {
      final response = await http.post(
        API.products,
        body: json.encode({
          "category": product.category,
          "title": product.title,
          "imageUrl": product.imageUrl,
          "description": product.description,
          "rating": product.rating,
          "price": product.price,
          "type": product.type,
        }),
      );
      print(response.body);
      final id = json.decode(response.body);
      final newProduct = Product(
        id: id["name"],
        category: product.category,
        title: product.title,
        imageUrl: product.imageUrl,
        description: product.descriptiongit
        rating: product.rating,
        price: product.price,
        type: product.type,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // update product
  Future<void> updateProduct(String id, Product updatedProduct) async {
    // add to firebase
    try {
      final prodIndex = _products.indexWhere((prod) => prod.id == id);
      final response = await http.patch(
        API.baseUrl + "/products/$id.json",
        body: json.encode({
          "category": updatedProduct.category,
          "title": updatedProduct.title,
          "imageUrl": updatedProduct.imageUrl,
          "description": updatedProduct.description,
          "rating": updatedProduct.rating,
          "price": updatedProduct.price,
          "type": updatedProduct.type,
        }),
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
}
