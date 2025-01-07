import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/edit_quantity_widget.dart';
import 'package:lucro_simples/components/sale_button.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class NewSalePageArgs {
  final Product product;
  final Customer customer;

  NewSalePageArgs({required this.product, required this.customer});
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
    sale = Sale(
      productId: widget.args.product.id!,
      productName: widget.args.product.name,
      productPhotoURL: widget.args.product.photoURL,
      customerId: widget.args.customer.id!,
      customerName: widget.args.customer.name,
      customerPhotoURL: widget.args.customer.photoURL,
      companyId: SessionManager.loggedCompany!.id!,
      saleDate: DateTime.now(),
      deliveryDate: DateTime.now(),
      quantity: 1,
      subtotal: widget.args.product.salePrice,
      total: widget.args.product.salePrice,
      profit: widget.args.product.salePrice - widget.args.product.costPrice,
    );
  }

  Future _registerSale() async {
    final saved = await repository.registerNewSale(sale);

    if (mounted) Navigator.pop(context, saved);
  }

  void _addQuantity() {
    sale.quantity++;
    _refreshValues();
  }

  void _removeQuantity() {
    if (sale.quantity == 1) {
      return FeedbackUser.toast(msg: 'Quantidade mínima permitida');
    }

    sale.quantity--;
    _refreshValues();
  }

  void _editQuantity(int newQuantity) {
    sale.quantity = newQuantity;
    _refreshValues();
  }

  void _refreshValues() {
    final totalCost = widget.args.product.costPrice * sale.quantity;

    sale.subtotal = widget.args.product.salePrice * sale.quantity;
    sale.total = sale.subtotal - sale.discount;
    sale.profit = sale.total - totalCost;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: widget.args.product.photoURL != null
                          ? Image.file(
                              File(widget.args.product.photoURL!),
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                            )
                          : const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.args.product.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatRealBr(widget.args.product.costPrice),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Preço de Custo',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        formatRealBr(widget.args.product.salePrice),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Preço de Venda',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: EditQuantityWidget(
                    remove: _removeQuantity,
                    add: _addQuantity,
                    edit: _editQuantity,
                    quantity: sale.quantity,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        formatRealBr(sale.discount),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Desconto',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        formatRealBr(sale.increase),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Acréscimo',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Você terá um lucro de ${formatRealBr(sale.profit)} com esta venda!',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.green.shade700,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SaleButton(
                onPressed: _registerSale,
                title: 'Registrar Venda',
                total: sale.total,
                iconData: Icons.add_shopping_cart_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
