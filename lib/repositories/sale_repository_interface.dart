import 'package:lucro_simples/entities/sale.dart';

abstract class ISaleRepository {
  Future<Sale> registerNewSale(Sale sale);
  Future<List<Sale>> getPaginatedSales(String search, int? limit, int? offset);
}
