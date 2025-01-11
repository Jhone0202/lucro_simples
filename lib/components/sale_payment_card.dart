import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/entities/payment_method.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';
import 'package:lucro_simples/utils/formaters_util.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

class SalePaymentCard extends StatefulWidget {
  const SalePaymentCard({
    super.key,
    required this.sale,
    required this.setPaymentMethod,
  });

  final Sale sale;
  final Function(PaymentMethod paymentMethod) setPaymentMethod;

  @override
  State<SalePaymentCard> createState() => _SalePaymentCardState();
}

class _SalePaymentCardState extends State<SalePaymentCard> {
  final saleRepository = getIt.get<ISaleRepository>();
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod? selected;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future _loadPaymentMethods() async {
    paymentMethods = await saleRepository.getPaymentMethods();
    selected = paymentMethods.firstOrNull;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.playlist_add_check_circle_sharp,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Pagamento',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<PaymentMethod>(
            value: selected,
            onChanged: (method) {
              if (method != null) {
                widget.setPaymentMethod(method);
                selected = method;
                setState(() {});
              }
            },
            items: paymentMethods
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            decoration: defaultFormDecoration(context),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text(formatRealBr(widget.sale.subtotal)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Desconto'),
              Text(formatRealBr(widget.sale.discount)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Acréscimo'),
              Text(formatRealBr(widget.sale.increase)),
            ],
          ),
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                formatRealBr(widget.sale.total),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
