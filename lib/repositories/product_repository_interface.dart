import 'package:lucro_simples/entities/product.dart';

abstract class IProductRepository {
  Future<Product> registerNewProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<List<Product>> getPaginatedProducts(
    String search,
    int? limit,
    int? offset,
  );
}
