import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/components/edit_quantity_widget.dart';
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
    return Container(
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '#${formatId(item.productId)}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatRealBr(item.total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    EditQuantityWidget(
                      showLabel: false,
                      remove: () {},
                      add: () {},
                      edit: (_) {},
                      quantity: item.quantity,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
