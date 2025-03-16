import 'dart:convert';

import 'package:fire_com/Model/user.dart';

class Product {
  String id;
  String categoryId;
  String createdUser;
  String createdAt;
  String name;
  String description;
  String color;
  String image;
  double price;
  double discount;
  String imageFile;
  User user;

  Product({
    required this.id,
    required this.categoryId,
    required this.createdUser,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.color,
    required this.image,
    required this.price,
    required this.discount,
    required this.imageFile,
    required this.user,
  });

  factory Product.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Product.empty();
    }
    return Product(
      id: json['id']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      createdUser: json['createdUser']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      imageFile: json['imageFile']?.toString() ?? '',
      user: User(json['user']["username"]?.toString() ?? '', json['user']["email"]?.toString() ?? '', json['user']["firstName"]?.toString() ?? '')
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'createdUser': createdUser,
      'createdAt': createdAt,
      'name': name,
      'description': description,
      'color': color,
      'image': image,
      'price': price,
      'discount': discount,
      'imageFile': imageFile,
    };
  }

  factory Product.empty() {
    return Product(
      id: '',
      categoryId: '',
      createdUser: '',
      createdAt: '',
      name: '',
      description: '',
      color: '',
      image: '',
      price: 0.0,
      discount: 0.0,
      imageFile: '',
      user: User('', '', '')
    );
  }
}
