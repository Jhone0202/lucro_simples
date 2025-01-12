import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  });

  final Sale sale;

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

  bool _validateAndSave(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;

    if (form == null) return true;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  void _editDiscount() {
    final formKey = GlobalKey<FormState>();
    final controller = MoneyMaskedTextController(
      leftSymbol: 'R\$',
      initialValue: widget.sale.discount,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Desconto'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration: defaultFormDecoration(context).copyWith(
              labelText: 'Desconto',
            ),
            validator: (_) {
              if (controller.numberValue < 0) {
                return 'Desconto não permitido';
              }

              final maxDiscount = widget.sale.subtotal + widget.sale.increase;
              if (controller.numberValue > maxDiscount) {
                return '${formatRealBr(maxDiscount)} é o máximo permitido';
              }

              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () {
              if (_validateAndSave(formKey)) {
                widget.sale.setDiscount(controller.numberValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _editIncrease() {
    final formKey = GlobalKey<FormState>();
    final controller = MoneyMaskedTextController(
      leftSymbol: 'R\$',
      initialValue: widget.sale.increase,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Acréscimo'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration: defaultFormDecoration(context).copyWith(
              labelText: 'Acréscimo',
            ),
            validator: (_) {
              if (controller.numberValue < 0) {
                return 'Acréscimo não permitido';
              }

              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () {
              if (_validateAndSave(formKey)) {
                widget.sale.setIncrease(controller.numberValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                widget.sale.setPaymentMethod(method);
                selected = method;
                setState(() {});
              }
            },
            items: paymentMethods
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            decoration: paymentDropDecoration(context).copyWith(
              isDense: true,
              contentPadding: const EdgeInsets.all(8),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).primaryColor,
            ),
            iconSize: 20,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text(formatRealBr(widget.sale.subtotal)),
            ],
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: _editDiscount,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Text('Desconto'),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.edit,
                      size: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      formatRealBr(widget.sale.discount),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _editIncrease,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Text('Acréscimo'),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.edit,
                      size: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      formatRealBr(widget.sale.increase),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.1)),
          const SizedBox(height: 4),
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
