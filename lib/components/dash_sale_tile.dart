import 'package:flutter/material.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/pages/sale/sale_details_page.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class DashSaleTile extends StatelessWidget {
  const DashSaleTile({super.key, required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        SaleDetailsPage.routeName,
        arguments: sale,
      ),
      title: Text(
        sale.customerName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatId(sale.id ?? 0),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            getFriendlyDateTime(sale.saleDate),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      leading: CircleFileImage(filePath: sale.customerPhotoURL),
      trailing: Text(
        formatRealBr(sale.total),
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Colors.green),
      ),
    );
  }
}
