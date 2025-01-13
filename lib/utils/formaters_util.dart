import 'package:intl/intl.dart';

String formatRealBr(double valor) {
  return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);
}

String getNamedDateTime(DateTime? dateTime, {bool? separator}) {
  if (dateTime == null) return '';
  if (separator == null || separator == false) {
    return DateFormat('dd MMM yyyy - HH:mm', 'pt_br').format(dateTime);
  } else {
    return DateFormat('dd MMM\nHH:mm', 'pt_br').format(dateTime).toUpperCase();
  }
}

String getFriendlyDateTime(DateTime? dateTime, {bool separated = false}) {
  if (dateTime == null) return 'Data não informada';

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateFormatted = DateFormat('dd MMM yyyy', 'pt_BR').format(dateTime);

  if (dateTime.isAfter(today)) {
    return 'Hoje às${separated ? '\n' : ' '}${DateFormat.Hm('pt_BR').format(dateTime)}';
  } else if (dateTime.isAfter(yesterday)) {
    return 'Ontem às${separated ? '\n' : ' '}${DateFormat.Hm('pt_BR').format(dateTime)}';
  } else {
    return '$dateFormatted às${separated ? '\n' : ' '}${DateFormat.Hm('pt_BR').format(dateTime)}';
  }
}

String formatId(int id) {
  return '#${NumberFormat('00000').format(id)}';
}

String getDay(DateTime dateTime) {
  return DateFormat('dd MMM', 'pt_br').format(dateTime);
}

String getPercent(double value, double total) {
  return '${(value * 100 / total).toStringAsFixed(2)}%';
}
