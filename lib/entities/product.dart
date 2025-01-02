import 'dart:convert';

class Product {
  int? id;
  String? photoURL;
  String name;
  double costPrice;
  double salePrice;

  Product({
    this.id,
    this.photoURL,
    required this.name,
    required this.costPrice,
    required this.salePrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'photoURL': photoURL,
      'name': name,
      'costPrice': costPrice,
      'salePrice': salePrice,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] != null ? map['id'] as int : null,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      name: map['name'] as String,
      costPrice: map['costPrice'] as double,
      salePrice: map['salePrice'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
