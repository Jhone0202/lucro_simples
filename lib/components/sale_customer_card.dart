import 'package:flutter/material.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/entities/sale_progess.dart';
import 'package:lucro_simples/pages/sale/sale_wizard_page.dart';

class SaleCustomerCard extends StatelessWidget {
  const SaleCustomerCard({
    super.key,
    required this.sale,
    this.readOnly = false,
  });

  final Sale sale;
  final bool readOnly;

  Future _changeCustomer(BuildContext context) async {
    final res = await Navigator.pushNamed(
      context,
      SaleWizardPage.routeName,
      arguments: SaleFlowType.customerSelection,
    ) as SaleProgress?;

    if (res?.customer != null) {
      sale.setCustomer(res!.customer!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle_rounded,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Cliente',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              onTap: readOnly ? null : () => _changeCustomer(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: CircleFileImage(filePath: sale.customerPhotoURL),
              title: Text(
                sale.customerName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                sale.customerPhoneNumber,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: readOnly
                  ? null
                  : Icon(
                      Icons.swap_horiz,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
