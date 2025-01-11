import 'package:flutter/material.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/sale.dart';

class SaleCustomerCard extends StatelessWidget {
  const SaleCustomerCard({
    super.key,
    required this.sale,
  });

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
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
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
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
              trailing: Icon(
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
