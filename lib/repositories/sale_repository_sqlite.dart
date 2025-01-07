import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';

class SaleRepositorySqlite extends ISaleRepository {
  @override
  Future<Sale> registerNewSale(Sale sale) async {
    final database = await LsDatabase().db;

    final id = await database.insert('sales', sale.toMap());

    return await _getSaleById(id);
  }

  Future<Sale> _getSaleById(int id) async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (res.isEmpty) throw 'Venda $id não encontrada';

    return Sale.fromMap(res.first);
  }

  @override
  Future<List<Sale>> getPaginatedSales(
    String search,
    int? limit,
    int? offset,
  ) async {
    final database = await LsDatabase().db;

    // TODO:Adicionar campos para buscar pelo nome do cliente ou produto
    final res = await database.query(
      'sales',
      orderBy: 'saleDate DESC',
      limit: limit,
      offset: offset,
    );

    return res.map((e) => Sale.fromMap(e)).toList();
  }
}
