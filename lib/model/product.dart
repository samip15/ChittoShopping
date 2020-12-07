import 'package:flutter/foundation.dart';

class Product {
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
