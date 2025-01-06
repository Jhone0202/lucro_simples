// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/new_sale_page.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

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
      body: ListView.builder(
        itemCount: sales.length,
        itemBuilder: (context, index) {
          final sale = sales[index];
          return ListTile(
            title: Text(getFriendlyDateTime(sale.saleDate)),
            subtitle: Text(formatRealBr(sale.total)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final product = await Navigator.pushNamed(
            context,
            ProductsPage.routeName,
            arguments: true,
          ) as Product?;

          if (product == null) return;

          final customer = await Navigator.pushNamed(
            context,
            CustomersPage.routeName,
            arguments: true,
          ) as Customer?;

          if (customer == null) return;

          final newSale = await Navigator.pushNamed(
            context,
            NewSalePage.routeName,
            arguments: NewSalePageArgs(product: product, customer: customer),
          ) as Sale?;

          if (newSale != null) {
            FeedbackUser.toast(msg: 'Venda registrada com Sucesso!');
          }
        },
        label: const Text('Nova Venda'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
