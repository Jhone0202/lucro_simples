import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/components/receipt_bottom_sheet.dart';
import 'package:lucro_simples/components/sale_customer_card.dart';
import 'package:lucro_simples/components/sale_delivery_card.dart';
import 'package:lucro_simples/components/sale_item_tile.dart';
import 'package:lucro_simples/components/sale_payment_card.dart';
import 'package:lucro_simples/components/sale_profit_card.dart';
import 'package:lucro_simples/components/secondary_button.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class SaleDetailsPage extends StatefulWidget {
  static const String routeName = 'sale_details_page';
  const SaleDetailsPage({super.key, required this.sale});

  final Sale sale;

  @override
  State<SaleDetailsPage> createState() => _SaleDetailsPageState();
}

class _SaleDetailsPageState extends State<SaleDetailsPage> {
  final repository = getIt.get<ISaleRepository>();
  Sale? detailedSale;

  @override
  void initState() {
    super.initState();
    _loadDetailedSale(widget.sale.id);
  }

  Future _loadDetailedSale(int? id) async {
    try {
      if (id == null) throw 'Id da venda não informado';

      detailedSale = await repository.getSaleDetails(id);
    } catch (e) {
      FeedbackUser.toast(msg: e.toString());
    } finally {
      setState(() {});
    }
  }

  Future _confirmAndDeleteSale(Sale sale) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Venda'),
        content: const Text('Essa ação não pode ser desfeita'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade900),
            child: const Text('Excluír'),
          ),
        ],
      ),
    );

    if (result == true) {
      await repository.deleteSale(sale);
      refreshDashboard.value = true;
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Venda ${formatId(widget.sale.id ?? 0)}'),
      ),
      body: detailedSale == null
          ? const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 1),
              ),
            )
          : ListView(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, i) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(),
                  ),
                  itemCount: detailedSale!.items.length,
                  itemBuilder: (context, i) => SaleItemTile(
                    item: detailedSale!.items[i],
                    readOnly: true,
                  ),
                ),
                SaleCustomerCard(
                  sale: detailedSale!,
                  readOnly: true,
                ),
                SaleDeliveryCard(
                  sale: detailedSale!,
                  readOnly: true,
                ),
                SalePaymentCard(
                  sale: detailedSale!,
                  readOnly: true,
                ),
                SaleProfitCard(profit: detailedSale!.profit),
                PrimaryButton(
                  onPressed: () => showReceipt(context, detailedSale!),
                  title: 'Ver Comprovante',
                  iconData: Icons.receipt,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                ),
                SecondaryButton(
                  onPressed: () => _confirmAndDeleteSale(detailedSale!),
                  title: 'Excluír Venda',
                  iconData: Icons.delete,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  contentColor: Colors.red.shade900,
                ),
              ],
            ),
    );
  }
}
