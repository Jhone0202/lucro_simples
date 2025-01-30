import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucro_simples/extensions/recase_extensions.dart';

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

String getDbDate(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd', 'pt_br').format(dateTime);
}

String getFriendlyPeriod(DateTimeRange period) {
  DateTime now = DateTime.now();
  DateTime start = period.start;
  DateTime end = period.end;

  final DateFormat dayMonth = DateFormat("d 'de' MMM", 'pt_BR');
  final DateFormat fullDate = DateFormat("d 'de' MMM yyyy", 'pt_BR');
  final DateFormat monthFormat = DateFormat("MMMM", 'pt_BR');

  if (_isSameDay(start, now) && _isSameDay(end, now)) {
    return "Hoje";
  }

  if (_isSameDay(start, now.subtract(const Duration(days: 6))) &&
      _isSameDay(end, now)) {
    return "Últimos 7 dias";
  }

  if (start.day == 1 &&
      end.day == DateTime(start.year, start.month + 1, 0).day &&
      start.month == end.month &&
      start.year == end.year) {
    return monthFormat.format(start).titleCase;
  }

  if (start.year == end.year) {
    return "${dayMonth.format(start)} - ${dayMonth.format(end)} ${end.year}";
  }

  return "${fullDate.format(start)} - ${fullDate.format(end)}";
}

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String getFormatedPercent(double value, double total) {
  if (value == 0 && total == 0) return '0%';

  double percent = (value * 100 / total);
  return percent % 1 == 0
      ? '${percent.toInt()}%'
      : '${percent.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'[.,]$'), '')}%';
}
