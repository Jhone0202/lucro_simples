import 'package:flutter/material.dart';
import 'package:lucro_simples/components/dotted_divider.dart';
import 'package:lucro_simples/components/receipt_row.dart';
import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key, required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green.withOpacity(0.1),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green.withOpacity(0.5),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Obrigado pela sua encomenda!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            formatId(sale.id!),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const DottedDivider(marginVertical: 16),
          ReceiptRow(
            label: 'Empresa',
            value: SessionManager.loggedCompany?.name ?? '',
            margin: EdgeInsets.zero,
          ),
          ReceiptRow(
            label: 'Cliente',
            value: sale.customerName,
          ),
          ReceiptRow(
            label: 'Telefone',
            value: sale.customerPhoneNumber,
          ),
          ReceiptRow(
            label: getDeliveryTypeName(sale.deliveryType),
            value: getNamedDateTime(sale.deliveryDate),
          ),
          if (sale.deliveryType == DELIVERY_TYPE.delivery)
            ReceiptRow(
              label: 'Taxa de Entrega',
              value: formatRealBr(sale.deliveryCost),
            ),
          const DottedDivider(marginVertical: 16),
          Row(
            children: [
              Text(
                'ITENS',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
          ),
          ...sale.items.map(
            (item) => ReceiptRow(
              label: '${item.productName} | ${item.quantity} UN',
              value: formatRealBr(item.total),
            ),
          ),
          const DottedDivider(marginVertical: 16),
          ReceiptRow(
            label: 'Forma de Pagamento',
            value: sale.paymentMethod.name,
            margin: EdgeInsets.zero,
          ),
          if (sale.discount != 0 || sale.increase != 0) ...[
            ReceiptRow(
              label: 'Subtotal',
              value: formatRealBr(sale.subtotal),
            ),
            ReceiptRow(
              label: 'Desconto',
              value: formatRealBr(sale.discount),
            ),
            ReceiptRow(
              label: 'Acréscimo',
              value: formatRealBr(sale.increase),
            ),
          ],
          ReceiptRow(
            label: 'Total',
            value: formatRealBr(sale.total),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              'Comprovante gerado pelo aplicativo Lucro Simples',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}
