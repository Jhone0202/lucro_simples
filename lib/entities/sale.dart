import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/sale_item.dart';

class Sale {
  int? id;
  int customerId;
  String? customerPhotoURL;
  String customerName;
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

  Sale({
    this.id,
    required this.customerId,
    this.customerPhotoURL,
    required this.customerName,
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
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerId': customerId,
      'customerPhotoURL': customerPhotoURL,
      'customerName': customerName,
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
}
