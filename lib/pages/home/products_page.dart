import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/helpers/adaptive_grid_helper.dart';
import 'package:lucro_simples/pages/product_register_page.dart';
import 'package:lucro_simples/repositories/product_repository_interface.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class ProductsPage extends StatefulWidget {
  static const String routeName = 'products_page';

  final bool getProduct;
  const ProductsPage({super.key, this.getProduct = false});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final repository = getIt.get<IProductRepository>();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    repository.getPaginatedProducts('', 100, 0).then((res) {
      products = res;
      setState(() {});
    }).catchError((error) {
      log(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.getProduct
          ? AppBar(title: const Text('Selecione o Produto'))
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AdaptiveGridHelper(
                minSizeItem: 200,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (widget.getProduct) {
                          Navigator.pop(context, product);
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.6,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: product.photoURL != null
                                    ? Image.file(
                                        File(product.photoURL!),
                                        fit: BoxFit.cover,
                                        width: double.maxFinite,
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              formatRealBr(product.salePrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          ProductRegisterPage.routeName,
        ),
        label: const Text('Cadastrar Produto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
