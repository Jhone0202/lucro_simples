// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/components/dash_sale_tile.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/sale/new_sale_page.dart';
import 'package:lucro_simples/pages/sale/sale_item_page.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';
import 'package:lucro_simples/utils/feedback_user.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final company = SessionManager.loggedCompany!;
  final repository = getIt.get<ISaleRepository>();

  List<Sale> sales = [];

  @override
  void initState() {
    super.initState();
    repository.getPaginatedSales('', 100, 0).then((res) {
      sales = res;
      setState(() {});
    });
  }

  Future _newSale() async {
    final customer = await Navigator.pushNamed(
      context,
      CustomersPage.routeName,
      arguments: true,
    ) as Customer?;

    if (customer == null) return;

    final product = await Navigator.pushNamed(
      context,
      ProductsPage.routeName,
      arguments: true,
    ) as Product?;

    if (product == null) return;

    final saleItem = await Navigator.pushNamed(
      context,
      SaleItemPage.routeName,
      arguments: product,
    ) as SaleItem?;

    if (saleItem == null) return;

    final newSale = await Navigator.pushNamed(
      context,
      NewSalePage.routeName,
      arguments: NewSalePageArgs(items: [saleItem], customer: customer),
    ) as Sale?;

    if (newSale != null) {
      FeedbackUser.toast(msg: 'Venda registrada com Sucesso!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleFileImage(filePath: company.photoURL),
          title: Text(company.name),
          subtitle: Text(company.userName),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Histórico de Vendas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: sales.length,
            itemBuilder: (context, index) => DashSaleTile(sale: sales[index]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newSale,
        label: const Text('Nova Venda'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
