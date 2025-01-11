import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucro_simples/components/animated_switch.dart';
import 'package:lucro_simples/entities/delivery_type.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/utils/formaters_util.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

class Delivery {
  DELIVERY_TYPE type;
  DateTime deliveryDate;
  double cost;

  Delivery({
    required this.type,
    required this.deliveryDate,
    required this.cost,
  });
}

class SaleDeliveryCard extends StatefulWidget {
  const SaleDeliveryCard({
    super.key,
    required this.sale,
    required this.setDelivery,
  });

  final Sale sale;
  final Function(Delivery delivery) setDelivery;

  @override
  State<SaleDeliveryCard> createState() => _SaleDeliveryCardState();
}

class _SaleDeliveryCardState extends State<SaleDeliveryCard> {
  late Delivery delivery;

  @override
  void initState() {
    super.initState();
    refreshDelivery();
  }

  void refreshDelivery() {
    delivery = Delivery(
      type: widget.sale.deliveryType,
      cost: widget.sale.deliveryCost,
      deliveryDate: widget.sale.deliveryDate,
    );

    setState(() {});
  }

  Future selectDateAndTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      initialDate: delivery.deliveryDate,
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(delivery.deliveryDate),
    );

    if (time == null) return;

    delivery.deliveryDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    widget.setDelivery(delivery);
    refreshDelivery();
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

  void editDeliveryCost() {
    final formKey = GlobalKey<FormState>();
    final controller = MoneyMaskedTextController(
      leftSymbol: 'R\$',
      initialValue: widget.sale.deliveryCost,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Taxa de Entrega'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration: defaultFormDecoration(context).copyWith(
              labelText: 'Taxa de Entrega',
            ),
            validator: (_) {
              if (controller.numberValue < 0) {
                return 'A taxa inválida';
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
                delivery.cost = controller.numberValue;
                widget.setDelivery(delivery);
                refreshDelivery();
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
                Icons.location_on,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Tipo de Entrega',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          AnimatedSwitch(
            option1: 'Retirada',
            option2: 'Entrega',
            onChanged: (selectedOption) {
              delivery.type = selectedOption == 'Retirada'
                  ? DELIVERY_TYPE.pickup
                  : DELIVERY_TYPE.delivery;
              delivery.cost = 0;

              widget.setDelivery(delivery);
              refreshDelivery();
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              onTap: selectDateAndTime,
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: Icon(
                Icons.calendar_month,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                getNamedDateTime(delivery.deliveryDate),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Icon(
                Icons.swap_horiz,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Durations.medium1,
            child: delivery.type == DELIVERY_TYPE.delivery
                ? Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      onTap: editDeliveryCost,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Icon(
                        Icons.attach_money,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        formatRealBr(widget.sale.deliveryCost),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: Icon(
                        Icons.swap_horiz,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
