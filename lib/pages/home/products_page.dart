import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/product_card.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/helpers/adaptive_grid_helper.dart';
import 'package:lucro_simples/pages/registers/product_register_page.dart';
import 'package:lucro_simples/repositories/product_repository_interface.dart';
import 'package:lucro_simples/utils/debouncer.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

class ProductsPage extends StatefulWidget {
  static const String routeName = 'products_page';

  final Function(Product)? onSelected;
  const ProductsPage({super.key, this.onSelected});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final repository = getIt.get<IProductRepository>();
  final searchController = TextEditingController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    repository.getPaginatedProducts(searchController.text, 100, 0).then((res) {
      products = res;
      setState(() {});
    });
  }

  Future _registerNewProduct() async {
    final newProduct = await Navigator.pushNamed(
      context,
      ProductRegisterPage.routeName,
    ) as Product?;

    if (newProduct != null) {
      products.insert(0, newProduct);
      setState(() {});
    }
  }

  Future _editProduct(Product product, int index) async {
    final newProduct = await Navigator.pushNamed(
      context,
      ProductRegisterPage.routeName,
      arguments: product,
    ) as Product?;

    if (newProduct != null) {
      products[index] = newProduct;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadProducts(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => Debouncer(action: _loadProducts),
                  decoration: defaultFormDecoration(context).copyWith(
                    labelText: 'Pesquisar Produto',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: FadeInUp(
                  child: AdaptiveGridHelper(
                    minSizeItem: 200,
                    itemCount: products.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: products[index],
                      onTap: () {
                        if (widget.onSelected != null) {
                          widget.onSelected!(products[index]);
                        } else {
                          _editProduct(products[index], index);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registerNewProduct,
        label: const Text('Cadastrar Produto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
