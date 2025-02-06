import 'package:flutter_test/flutter_test.dart';

import '../mocks/sale_mock.dart';

void main() {
  final dataMock = SaleMock();

  test('Calculate subtotal, total and profit', () {
    final sale = dataMock.simpleSale();
    final item = dataMock.saleItemCake();
    final delivery = dataMock.delivery();
    final paymentMethod = dataMock.payWithDiscount();

    sale.addItem(item);
    sale.setDelivery(delivery);
    sale.setPaymentMethod(paymentMethod);

    expect(sale.subtotal, 35);
    expect(sale.increase, 0); // 0% de 35
    expect(sale.discount, 3.50); // 10% de 35
    expect(sale.profit, 3);
    expect(sale.total, 31.5);
  });

  test('Changing payment method recalculates amounts', () {
    final sale = dataMock.simpleSale();
    final item = dataMock.saleItemCake();
    final delivery = dataMock.delivery();
    final paymentMethod = dataMock.payWithDiscountAndIncrease();

    sale.addItem(item);
    sale.setDelivery(delivery);

    expect(sale.total, 35);

    sale.setPaymentMethod(paymentMethod);

    expect(sale.increase, 1.75); // 5% de 35
    expect(sale.discount, 3.50); // 10% de 35
    expect(sale.subtotal, 35);
    expect(sale.profit, 3);
    expect(sale.total, 33.25);
  });

  test('Recalculate when removing an item', () {
    final sale = dataMock.simpleSale();
    final cake = dataMock.saleItemCake();
    final juice = dataMock.saleItemJuice();

    sale.addItem(cake);
    sale.addItem(juice);

    expect(sale.total, 30);

    sale.removeItem(juice);

    expect(sale.total, 25);
  });
}
