import 'package:flutter/material.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class SaleProfitCard extends StatelessWidget {
  const SaleProfitCard({super.key, required this.profit});

  final double profit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            'Seu lucro com esta venda é de ${formatRealBr(profit)}!',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.green,
                ),
          ),
        ],
      ),
    );
  }
}
