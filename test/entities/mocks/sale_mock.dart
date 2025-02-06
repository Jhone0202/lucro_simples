import 'package:lucro_simples/components/sale_delivery_card.dart';
import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/payment_method.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/entities/sale_item.dart';

class SaleMock {
  Sale simpleSale() {
    return Sale(
      id: null,
      customerId: 1,
      customerName: 'Consumidor Final',
      customerPhoneNumber: '+00 (00) 0 0000-0000',
      customerPhotoURL: null,
      companyId: 1,
      saleDate: DateTime.fromMillisecondsSinceEpoch(1738797585288),
      deliveryDate: DateTime.fromMillisecondsSinceEpoch(1738797585288),
      items: [],
      deliveryCost: 0.0,
      deliveryType: DELIVERY_TYPE.pickup,
      discount: 0.0,
      increase: 0.0,
      subtotal: 25,
      total: 25,
      profit: 6.4,
      paymentMethodId: 1,
      paymentMethod: PaymentMethod(
        id: 1,
        increasePercent: 0,
        discountPercent: 0,
        name: 'Dinheiro',
      ),
    );
  }

  SaleItem saleItemCake() {
    return SaleItem(
      id: null,
      productId: 1,
      saleId: 0,
      productName: 'Bolo de Cenoura 1kg',
      productPhotoURL: null,
      quantity: 1,
      productPrice: 25,
      productCostPrice: 18.5,
      total: 25,
      profit: 6.5,
    );
  }

  SaleItem saleItemJuice() {
    return SaleItem(
      id: null,
      productId: 1,
      saleId: 0,
      productName: 'Suco de Laranja 300ml',
      productPhotoURL: null,
      quantity: 1,
      productPrice: 5,
      productCostPrice: 2,
      total: 5,
      profit: 3,
    );
  }

  Delivery delivery() {
    return Delivery(
      cost: 10,
      deliveryDate: DateTime.now(),
      type: DELIVERY_TYPE.delivery,
    );
  }

  PaymentMethod payWithDiscountAndIncrease() {
    return PaymentMethod(
      id: 1,
      increasePercent: 5,
      discountPercent: 10,
      name: 'Teste',
    );
  }

  PaymentMethod payWithDiscount() {
    return PaymentMethod(
      id: 1,
      increasePercent: 0,
      discountPercent: 10,
      name: 'Teste',
    );
  }
}
