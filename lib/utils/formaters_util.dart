import 'package:intl/intl.dart';

String formatRealBr(double valor) {
  return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);
}
