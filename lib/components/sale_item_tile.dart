import 'package:flutter/material.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class SaleItemTile extends StatelessWidget {
  const SaleItemTile({
    super.key,
    required this.item,
  });

  final SaleItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.productName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text('Quantidade ${item.quantity}'),
      leading: CircleFileImage(filePath: item.productPhotoURL),
      trailing: Text(
        formatRealBr(item.total),
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Colors.green),
      ),
    );
  }
}
