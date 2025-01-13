import 'dart:convert';

class MonthRegistersSerie {
  final DateTime date;
  final double total;
  final double profit;

  MonthRegistersSerie(this.date, this.total, this.profit);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'total': total,
      'profit': profit,
    };
  }

  factory MonthRegistersSerie.fromMap(Map<String, dynamic> map) {
    return MonthRegistersSerie(
      DateTime.parse(map['date'] as String),
      (map['total'] as num).toDouble(),
      (map['profit'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthRegistersSerie.fromJson(String source) =>
      MonthRegistersSerie.fromMap(json.decode(source) as Map<String, dynamic>);
}
