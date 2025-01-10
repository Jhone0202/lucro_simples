// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SaleItem {
  int? id;
  int productId;
  int saleId;
  String productName;
  String? productPhotoURL;
  int quantity;
  double productPrice;
  double total;
  double profit;

  SaleItem({
    this.id,
    required this.productId,
    this.saleId = 0,
    required this.productName,
    this.productPhotoURL,
    required this.quantity,
    required this.productPrice,
    required this.total,
    required this.profit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'saleId': saleId,
      'productName': productName,
      'productPhotoURL': productPhotoURL,
      'quantity': quantity,
      'productPrice': productPrice,
      'total': total,
      'profit': profit,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'] != null ? map['id'] as int : null,
      productId: map['productId'] as int,
      saleId: map['saleId'] as int,
      productName: map['productName'] as String,
      productPhotoURL: map['productPhotoURL'] != null
          ? map['productPhotoURL'] as String
          : null,
      quantity: map['quantity'] as int,
      productPrice: map['productPrice'] as double,
      total: map['total'] as double,
      profit: map['profit'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaleItem.fromJson(String source) =>
      SaleItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
