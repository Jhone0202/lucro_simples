// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class ImportCustomersTile extends StatelessWidget {
  const ImportCustomersTile({
    super.key,
    required this.customer,
    this.selected = false,
    required this.onChanged,
    this.already = false,
  });

  final Customer customer;
  final bool selected;
  final Function(bool?) onChanged;
  final bool already;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: selected,
      onChanged: already ? null : onChanged,
      isThreeLine: already,
      title: Text(
        customer.name,
        style: AppTheme.textStyles.titleSmall,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            customer.phoneNumber,
            style: AppTheme.textStyles.subtitleMedium,
          ),
          if (already)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    size: 10,
                    color: AppTheme.colors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Já Cadastrado',
                    style: AppTheme.textStyles.captionMedium.copyWith(
                      color: AppTheme.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      secondary: customer.photoURL != null
          ? CircleFileImage(filePath: customer.photoURL, size: 48)
          : CircleAvatar(
              backgroundImage: null,
              radius: 24,
              backgroundColor: AppTheme.colors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.person, color: AppTheme.colors.primary),
            ),
    );
  }
}
