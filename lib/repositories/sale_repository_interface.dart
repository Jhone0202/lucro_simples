import 'package:lucro_simples/entities/payment_method.dart';
import 'package:lucro_simples/entities/sale.dart';

abstract class ISaleRepository {
  Future<Sale> registerNewSale(Sale sale);
  Future<List<Sale>> getPaginatedSales(String search, int? limit, int? offset);
  Future<Sale> getSaleDetails(int saleId);
  Future<List<PaymentMethod>> getPaymentMethods();
  Future deleteSale(Sale sale);
}
