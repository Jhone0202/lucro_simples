import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/entities/payment_method.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';

class SaleRepositorySqlite extends ISaleRepository {
  @override
  Future<Sale> registerNewSale(Sale sale) async {
    final database = await LsDatabase().db;

    final id = await database.transaction((txn) async {
      final saleId = await txn.insert('sales', sale.toMap());

      for (var item in sale.items) {
        item.saleId = saleId;
        await txn.insert('sale_items', item.toMap());
      }

      return saleId;
    });

    return await _getSaleById(id);
  }

  Future<Sale> _getSaleById(int id) async {
    final database = await LsDatabase().db;

    final saleRes = await database.query(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (saleRes.isEmpty) throw 'Venda $id não encontrada';

    final itemsRes = await database.query(
      'sale_items',
      where: 'saleId = ?',
      whereArgs: [id],
    );

    final items = itemsRes.map((e) => SaleItem.fromMap(e)).toList();

    return Sale.fromMap(saleRes.first, items);
  }

  @override
  Future<List<Sale>> getPaginatedSales(
    String search,
    int? limit,
    int? offset,
  ) async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'sales',
      where: search.isEmpty ? null : 'customerName LIKE ?',
      whereArgs: search.isEmpty ? null : ['%$search%'],
      orderBy: 'saleDate DESC',
      limit: limit,
      offset: offset,
    );

    return res.map((e) => Sale.fromMap(e)).toList();
  }

  @override
  Future<Sale> getSaleDetails(int saleId) async {
    final database = await LsDatabase().db;

    final saleRes = await database.query(
      'sales',
      where: 'id = ?',
      whereArgs: [saleId],
    );

    if (saleRes.isEmpty) throw 'Venda $saleId não encontrada';

    final itemsRes = await database.query(
      'sale_items',
      where: 'saleId = ?',
      whereArgs: [saleId],
    );

    final items = itemsRes.map((e) => SaleItem.fromMap(e)).toList();
    return Sale.fromMap(saleRes.first, items);
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    final database = await LsDatabase().db;

    final res = await database.query('payment_methods');

    return res.map((e) => PaymentMethod.fromMap(e)).toList();
  }
}
