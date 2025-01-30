import 'package:flutter/material.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/pages/sale/sale_details_page.dart';
import 'package:lucro_simples/themes/app_theme.dart';
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
        style: AppTheme.textStyles.titleSmall,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatId(sale.id ?? 0),
            style: AppTheme.textStyles.captionMedium.copyWith(
              color: Colors.black54,
            ),
          ),
          Text(
            getFriendlyDateTime(sale.saleDate),
            style: AppTheme.textStyles.captionMedium.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
      leading: CircleFileImage(filePath: sale.customerPhotoURL),
      trailing: Text(
        formatRealBr(sale.total),
        style: AppTheme.textStyles.caption.copyWith(
          color: AppTheme.colors.primary,
        ),
      ),
    );
  }
}
