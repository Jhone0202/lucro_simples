import 'package:flutter/material.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class SaleStep<T> extends StatelessWidget {
  final String title;
  final String buttonText;
  final String route;
  final T? selectedItem;
  final Function(T) onSelected;

  const SaleStep({
    super.key,
    required this.title,
    required this.buttonText,
    required this.route,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: AppTheme.textStyles.titleSmall),
        const SizedBox(height: 16),
        if (selectedItem != null)
          Text(
            selectedItem.toString(),
            style: AppTheme.textStyles.subtitleMedium,
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              route,
              arguments: true,
            ) as T?;

            if (result != null) onSelected(result);
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
