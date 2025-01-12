import 'package:flutter/material.dart';
import 'package:lucro_simples/components/sale_delivery_card.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/payment_method.dart';
import 'package:lucro_simples/entities/sale_item.dart';

class Sale extends ChangeNotifier {
  int? id;
  int customerId;
  String? customerPhotoURL;
  String customerName;
  String customerPhoneNumber;
  int companyId;
  DateTime saleDate;
  DateTime deliveryDate;
  List<SaleItem> items;
  double deliveryCost;
  DELIVERY_TYPE deliveryType;
  double discount;
  double increase;
  double subtotal;
  double total;
  double profit;
  int paymentMethodId;

  PaymentMethod paymentMethod = PaymentMethod(name: 'Dinheiro');

  Sale({
    this.id,
    required this.customerId,
    this.customerPhotoURL,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.companyId,
    required this.saleDate,
    required this.deliveryDate,
    required this.items,
    required this.deliveryCost,
    required this.deliveryType,
    required this.discount,
    required this.increase,
    required this.subtotal,
    required this.total,
    required this.profit,
    required this.paymentMethodId,
  }) {
    for (var item in items) {
      item.setSaleCallback(refreshValues);
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerId': customerId,
      'customerPhotoURL': customerPhotoURL,
      'customerName': customerName,
      'customerPhoneNumber': customerPhoneNumber,
      'companyId': companyId,
      'saleDate': saleDate.millisecondsSinceEpoch,
      'deliveryDate': deliveryDate.millisecondsSinceEpoch,
      'deliveryCost': deliveryCost,
      'deliveryType': deliveryType.toString().split('.').last,
      'discount': discount,
      'increase': increase,
      'subtotal': subtotal,
      'total': total,
      'profit': profit,
      'paymentMethodId': paymentMethodId,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map, [List<SaleItem>? saleItems]) {
    return Sale(
      id: map['id'] != null ? map['id'] as int : null,
      customerId: map['customerId'] as int,
      customerPhotoURL: map['customerPhotoURL'] != null
          ? map['customerPhotoURL'] as String
          : null,
      customerName: map['customerName'] as String,
      customerPhoneNumber: map['customerPhoneNumber'] as String,
      companyId: map['companyId'] as int,
      saleDate: DateTime.fromMillisecondsSinceEpoch(map['saleDate'] as int),
      deliveryDate:
          DateTime.fromMillisecondsSinceEpoch(map['deliveryDate'] as int),
      items: saleItems ?? [],
      deliveryCost: map['deliveryCost'] as double,
      deliveryType: DELIVERY_TYPE.values.firstWhere(
        (e) => e.toString().split('.').last == map['deliveryType'],
      ),
      discount: map['discount'] as double,
      increase: map['increase'] as double,
      subtotal: map['subtotal'] as double,
      total: map['total'] as double,
      profit: map['profit'] as double,
      paymentMethodId: map['paymentMethodId'] as int,
    );
  }

  void setCustomer(Customer customer) {
    customerId = customer.id!;
    customerName = customer.name;
    customerPhoneNumber = customer.phoneNumber;
    customerPhotoURL = customer.photoURL;
    notifyListeners();
  }

  void addItem(SaleItem saleItem) {
    saleItem.setSaleCallback(refreshValues);
    items.add(saleItem);
    refreshValues();
  }

  void setPaymentMethod(PaymentMethod method) {
    if (method.id == null) throw 'Método de pagamento inválido';
    paymentMethodId = method.id!;
    paymentMethod = method;
    refreshValues();
  }

  void setDiscount(double discount) {
    this.discount = discount;
    refreshValues(refreshFromPayment: false);
  }

  void setIncrease(double increase) {
    this.increase = increase;
    refreshValues(refreshFromPayment: false);
  }

  void setDelivery(Delivery delivery) {
    deliveryCost = delivery.cost;
    deliveryDate = delivery.deliveryDate;
    deliveryType = delivery.type;
    refreshValues();
  }

  void refreshValues({bool refreshFromPayment = true}) {
    final double profit = items.fold(0, (sum, i) => sum + i.profit);
    final double itemsTotal = items.fold(0, (sum, i) => sum + i.total);
    final double subtotal = itemsTotal + deliveryCost;

    final paymentIncrease = double.parse(
      (subtotal * paymentMethod.increasePercent / 100).toStringAsFixed(2),
    );

    if (refreshFromPayment) {
      increase = paymentIncrease;
      discount = double.parse(
        (subtotal * paymentMethod.discountPercent / 100).toStringAsFixed(2),
      );
    }

    final double total = subtotal + increase - discount;

    this.subtotal = subtotal;
    this.total = total;
    this.profit = profit - paymentIncrease - discount + increase;
    notifyListeners();
  }
}
