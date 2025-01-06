import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

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
  final Function(int newQuantity) edit;
  final int quantity;
  final bool showLabel;

  bool _validateAndSave(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;

    if (form == null) return true;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  void _editQuantity(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: quantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Quantidade'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration: defaultFormDecoration(context).copyWith(
              labelText: 'Quantidade',
            ),
            validator: (v) {
              if (v?.trim().isEmpty == true) {
                return 'Informe uma quantidade';
              }

              final quantity = int.tryParse(v!);
              if (quantity == null || quantity <= 0) {
                return 'A quantidade deve ser maior que 0';
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
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    ).then((res) {
      if (res is String) {
        final newQuantity = int.parse(res);
        if (newQuantity != quantity) edit(newQuantity);
      }
    });
  }

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
                icon: Icon(
                  Icons.remove_circle_outline,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _editQuantity(context),
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
