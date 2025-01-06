import 'package:flutter/material.dart';

class EditQuantityWidget extends StatelessWidget {
  const EditQuantityWidget({
    super.key,
    required this.remove,
    required this.add,
    required this.edit,
    required this.quantity,
    this.showLabel = true,
  });

  final VoidCallback remove;
  final VoidCallback add;
  final VoidCallback edit;
  final int quantity;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: quantity > 999 ? 140 : 120,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: remove,
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: edit,
                  child: Text(
                    '$quantity',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: add,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        if (showLabel)
          Text(
            'Quantidade',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
      ],
    );
  }
}
