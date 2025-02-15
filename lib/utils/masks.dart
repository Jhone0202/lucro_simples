import 'package:extended_masked_text/extended_masked_text.dart';

final phoneMask = MaskedTextController(mask: '+55 (00) 00000-0000');

MoneyMaskedTextController moneyMaskedTextController({double? initialValue}) {
  return MoneyMaskedTextController(
    leftSymbol: 'R\$',
    initialValue: initialValue,
  );
}
