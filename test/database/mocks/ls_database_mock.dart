import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/customer_types.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale.dart';

class LsDatabaseMock {
  Company getCompany({int? id}) {
    return Company(
      id: id,
      name: 'Celebre com Pudim',
      userName: 'Ana Brito',
    );
  }

  Product getProduct({int? id}) {
    return Product(
      id: id,
      name: 'Pudim 550g',
      costPrice: 28,
      salePrice: 38,
    );
  }

  Customer getCustomer({int? id}) {
    return Customer(
      id: id,
      name: 'Maicon Jhone',
      phoneNumber: '77 98861-4661',
      type: IndividualCustomer(),
    );
  }

  Sale getSale({
    required int productId,
    required int customerId,
    required int companyId,
  }) {
    return Sale(
      productId: productId,
      customerId: customerId,
      companyId: companyId,
      saleDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
      quantity: 1,
      discount: 3,
      subtotal: 38,
      total: 35,
      profit: 7,
    );
  }
}
