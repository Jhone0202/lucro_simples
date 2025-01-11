import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/components/sale_customer_card.dart';
import 'package:lucro_simples/components/sale_delivery_card.dart';
import 'package:lucro_simples/components/sale_item_tile.dart';
import 'package:lucro_simples/components/sale_payment_card.dart';
import 'package:lucro_simples/components/sale_profit_card.dart';
import 'package:lucro_simples/components/secondary_button.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/payment_method.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/sale/sale_item_page.dart';
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
  PaymentMethod paymentMethod = PaymentMethod(name: 'Dinheiro');

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
    );
  }

  Future _registerSale() async {
    final saved = await repository.registerNewSale(sale);

    if (mounted) Navigator.pop(context, saved);
  }

  Future _selectAndAddNewItem() async {
    final product = await Navigator.pushNamed(
      context,
      ProductsPage.routeName,
      arguments: true,
    ) as Product?;

    if (product == null) return;

    if (!mounted) return;

    final saleItem = await Navigator.pushNamed(
      context,
      SaleItemPage.routeName,
      arguments: product,
    ) as SaleItem?;

    if (saleItem == null) return;

    sale.items.add(saleItem);
    _refreshValues();
  }

  void setPaymentMethod(PaymentMethod method) {
    if (method.id == null) throw 'Método de pagamento inválido';

    sale.paymentMethodId = method.id!;
    paymentMethod = method;

    _refreshValues();
  }

  void setDiscount(double discount) {
    sale.discount = discount;
    _refreshValues(refreshFromPayment: false);
  }

  void setIncrease(double increase) {
    sale.increase = increase;
    _refreshValues(refreshFromPayment: false);
  }

  void setDelivery(Delivery delivery) {
    sale.deliveryCost = delivery.cost;
    sale.deliveryDate = delivery.deliveryDate;
    sale.deliveryType = delivery.type;

    _refreshValues();
  }

  void _refreshValues({bool refreshFromPayment = true}) {
    final double profit = sale.items.fold(0, (sum, i) => sum + i.profit);
    final double itemsTotal = sale.items.fold(0, (sum, i) => sum + i.total);
    final double subtotal = itemsTotal + sale.deliveryCost;

    final paymentIncrease = double.parse(
      (subtotal * paymentMethod.increasePercent / 100).toStringAsFixed(2),
    );

    if (refreshFromPayment) {
      sale.increase = paymentIncrease;
      sale.discount = double.parse(
        (subtotal * paymentMethod.discountPercent / 100).toStringAsFixed(2),
      );
    }

    final double total = subtotal + sale.increase - sale.discount;

    sale.subtotal = subtotal;
    sale.total = total;
    sale.profit = profit - paymentIncrease - sale.discount + sale.increase;

    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
              itemBuilder: (context, i) => SaleItemTile(item: sale.items[i]),
            ),
            SecondaryButton(
              onPressed: _selectAndAddNewItem,
              title: 'Adicionar Item',
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              iconData: Icons.add,
            ),
            SaleCustomerCard(sale: sale),
            SaleDeliveryCard(
              sale: sale,
              setDelivery: setDelivery,
            ),
            SalePaymentCard(
              sale: sale,
              setPaymentMethod: setPaymentMethod,
              setDiscount: setDiscount,
              setIncrease: setIncrease,
            ),
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
    );
  }
}
