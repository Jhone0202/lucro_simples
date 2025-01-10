import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';

class NewSalePageArgs {
  final List<SaleItem> items;
  final Customer customer;

  NewSalePageArgs({required this.items, required this.customer});
}

class NewSalePage extends StatefulWidget {
  static const String routeName = 'new_sale_page';

  final NewSalePageArgs args;
  const NewSalePage({super.key, required this.args});

  @override
  State<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends State<NewSalePage> {
  final repository = getIt.get<ISaleRepository>();
  late Sale sale;

  @override
  void initState() {
    super.initState();
    initSale();
  }

  void initSale() {
    final customer = widget.args.customer;
    final items = widget.args.items;
    final double subtotal = items.fold(0, (sum, i) => sum + i.total);
    final double profit = items.fold(0, (sum, i) => sum + i.profit);

    sale = Sale(
      customerId: customer.id!,
      customerName: customer.name,
      customerPhotoURL: customer.photoURL,
      companyId: SessionManager.loggedCompany!.id!,
      saleDate: DateTime.now(),
      deliveryDate: DateTime.now(),
      items: items,
      deliveryCost: 0,
      deliveryType: DELIVERY_TYPE.pickup,
      discount: 0,
      increase: 0,
      subtotal: subtotal,
      total: subtotal,
      profit: profit,
      paymentMethodId: 1,
    );
  }

  Future _registerSale() async {
    final saved = await repository.registerNewSale(sale);

    if (mounted) Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sale.items.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(sale.items[index].productName),
            ),
          ),
          PrimaryButton(
            onPressed: _registerSale,
            title: 'Concluír Venda',
          ),
        ],
      ),
    );
  }
}
