import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/components/edit_quantity_widget.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/formaters_util.dart';
import 'package:provider/provider.dart';

class SaleItemTile extends StatelessWidget {
  const SaleItemTile({
    super.key,
    required this.item,
    this.removeItem,
    this.readOnly = false,
  });

  final SaleItem item;
  final Function(SaleItem item)? removeItem;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SaleItem>.value(
      value: item,
      child: Consumer<SaleItem>(
        builder: (context, item, _) => Container(
          height: 112,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 96,
                height: 96,
                margin: const EdgeInsets.only(right: 12),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: item.productPhotoURL != null
                    ? Image.file(
                        File(item.productPhotoURL!),
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                      )
                    : const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 2,
                      style: AppTheme.textStyles.titleSmall,
                    ),
                    Text(
                      formatId(item.productId),
                      style: AppTheme.textStyles.captionMedium.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    if (readOnly)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${formatRealBr(item.productPrice)} X ${item.quantity} = ${formatRealBr(item.total)}',
                          style: AppTheme.textStyles.caption.copyWith(
                            color: AppTheme.colors.content,
                          ),
                        ),
                      )
                    else ...[
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatRealBr(item.total),
                              style: AppTheme.textStyles.titleSmall,
                            ),
                          ),
                          EditQuantityWidget(
                            showLabel: false,
                            removeItem: removeItem != null
                                ? () => removeItem!(item)
                                : null,
                            remove: item.removeQuantity,
                            add: item.addQuantity,
                            edit: item.editQuantity,
                            quantity: item.quantity,
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
