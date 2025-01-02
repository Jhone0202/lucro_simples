import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/repositories/product_repository_interface.dart';

class ProductRepositorySqlite extends IProductRepository {
  @override
  Future<Product> registerNewProduct(Product product) async {
    final database = await LsDatabase().db;

    final existingProduct = await _getProductByKey('name', product.name);

    if (existingProduct != null) {
      throw 'Você já cadastrou um produto com o nome ${product.name}';
    }

    final id = await database.insert('products', product.toMap());

    final savedProduct = await _getProductByKey('id', id);

    return savedProduct!;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    if (product.id == null) throw 'Produto sem ID informado';

    final database = await LsDatabase().db;

    await database.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );

    final updatedProduct = await _getProductByKey('id', product.id);

    return updatedProduct!;
  }

  Future<Product?> _getProductByKey(String key, dynamic value) async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'products',
      where: '$key = ?',
      whereArgs: [value],
    );

    if (res.isEmpty) return null;

    return Product.fromMap(res.first);
  }

  @override
  Future<List<Product>> getPaginatedProducts(
    String search,
    int? limit,
    int? offset,
  ) async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'products',
      where: 'name LIKE "%?%"',
      whereArgs: [search],
      orderBy: 'TRIM(name)',
      limit: limit,
      offset: offset,
    );

    return res.map((e) => Product.fromMap(e)).toList();
  }
}
