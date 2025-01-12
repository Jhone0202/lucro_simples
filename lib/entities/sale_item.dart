import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lucro_simples/utils/feedback_user.dart';

class SaleItem extends ChangeNotifier {
  int? id;
  int saleId;
  int productId;
  String productName;
  String? productPhotoURL;
  double productPrice;
  double productCostPrice;
  int quantity;
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
    required this.productCostPrice,
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
      'productCostPrice': productCostPrice,
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
      productCostPrice: map['productCostPrice'] as double,
      total: map['total'] as double,
      profit: map['profit'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaleItem.fromJson(String source) =>
      SaleItem.fromMap(json.decode(source) as Map<String, dynamic>);

  void Function()? _onSaleUpdate;

  void setSaleCallback(void Function() callback) {
    _onSaleUpdate = callback;
  }

  void addQuantity() {
    quantity++;
    refreshValues();
  }

  void removeQuantity() {
    if (quantity == 1) {
      return FeedbackUser.toast(msg: 'Quantidade mínima permitida');
    }

    quantity--;
    refreshValues();
  }

  void editQuantity(int newQuantity) {
    quantity = newQuantity;
    refreshValues();
  }

  void refreshValues() {
    final totalCost = productCostPrice * quantity;

    total = productPrice * quantity;
    profit = total - totalCost;

    notifyListeners();
    _onSaleUpdate?.call();
  }
}
