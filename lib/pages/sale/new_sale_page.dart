import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/components/receipt_bottom_sheet.dart';
import 'package:lucro_simples/components/sale_customer_card.dart';
import 'package:lucro_simples/components/sale_delivery_card.dart';
import 'package:lucro_simples/components/sale_item_tile.dart';
import 'package:lucro_simples/components/sale_payment_card.dart';
import 'package:lucro_simples/components/sale_profit_card.dart';
import 'package:lucro_simples/components/secondary_button.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/payment_method.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/entities/sale_progess.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/sale/sale_wizard_page.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';
import 'package:provider/provider.dart';

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
      customerPhoneNumber: customer.phoneNumber,
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
      paymentMethod: PaymentMethod(name: 'Dinheiro'),
    );
  }

  Future _registerSale() async {
    if (sale.items.isEmpty) throw 'Adicione um item para concluír a venda';

    final saved = await repository.registerNewSale(sale);

    if (mounted) {
      showReceipt(context, saved, () => Navigator.pop(context, saved));
    }
  }

  Future _selectAndAddNewItem() async {
    final progress = await Navigator.pushNamed(
      context,
      SaleWizardPage.routeName,
      arguments: SaleFlowType.productWithItemSelection,
    ) as SaleProgress?;

    if (progress?.item != null) sale.addItem(progress!.item!);
  }

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar saída'),
        content: const Text('A venda será perdida'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future _showDeleteDialog(SaleItem item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('Deseja remover o item ${item.productName} da venda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade900),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (result == true) sale.removeItem(item);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Sale>.value(
      value: sale,
      child: Consumer<Sale>(
        builder: (context, sale, _) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) return;

            final bool shouldPop = await _showExitConfirmationDialog();

            if (context.mounted && shouldPop) Navigator.pop(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Nova Venda'),
            ),
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, i) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(),
                  ),
                  itemCount: sale.items.length,
                  itemBuilder: (context, i) => SaleItemTile(
                    item: sale.items[i],
                    removeItem: _showDeleteDialog,
                  ),
                ),
                SecondaryButton(
                  onPressed: _selectAndAddNewItem,
                  title: 'Adicionar Item',
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  iconData: Icons.add,
                ),
                SaleCustomerCard(sale: sale),
                SaleDeliveryCard(sale: sale),
                SalePaymentCard(sale: sale),
                SaleProfitCard(profit: sale.profit),
                PrimaryButton(
                  onPressed: _registerSale,
                  title: 'Concluír Venda',
                  iconData: Icons.check,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
