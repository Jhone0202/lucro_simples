import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: product.photoURL != null
                      ? Image.file(
                          File(product.photoURL!),
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                        )
                      : const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.textStyles.titleSmall,
              ),
              Text(
                formatRealBr(product.salePrice),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.textStyles.subtitleMedium.copyWith(
                  color: AppTheme.colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
