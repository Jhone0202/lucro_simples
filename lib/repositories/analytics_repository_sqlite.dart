import 'package:flutter/material.dart';
import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';
import 'package:lucro_simples/services/config_service.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class AnalyticsRepositorySqlite extends IAnalyticsRepository {
  final ConfigService config;

  AnalyticsRepositorySqlite(this.config);

  @override
  Future<List<MonthRegistersSerie>> getByPeriod(DateTimeRange period) async {
    final database = await LsDatabase().db;

    final query = '''
      WITH RECURSIVE custom_period AS (
          SELECT DATE(? || ' 00:00:00') AS date
          UNION ALL
          SELECT DATE(date, '+1 day')
          FROM custom_period
          WHERE date < DATE(? || ' 23:59:59')
      )
      SELECT 
          d.date AS date,
          COALESCE(SUM(s.total), 0) AS total,
          COALESCE(SUM(s.profit), 0) AS profit
      FROM custom_period d
      LEFT JOIN sales s 
          ON DATE(s.${config.salesAggregationDate} / 1000, 'unixepoch', 'localtime') = d.date
      GROUP BY d.date
      ORDER BY d.date ASC;
    ''';

    final start = getDbDate(period.start);
    final end = getDbDate(period.end);

    final res = await database.rawQuery(query, [start, end]);
    return res.map((e) => MonthRegistersSerie.fromMap(e)).toList();
  }

  @override
  Future<MonthRegistersSerie> getTodayResume() async {
    final database = await LsDatabase().db;

    final query = '''
      SELECT 
        COALESCE(DATE(${config.salesAggregationDate} / 1000, 'unixepoch', 'localtime'), DATE('now', 'localtime')) AS date,
        COALESCE(SUM(total), 0) AS total,
        COALESCE(SUM(profit), 0) AS profit
      FROM sales
      WHERE DATE(${config.salesAggregationDate} / 1000, 'unixepoch', 'localtime') = DATE('now', 'localtime');
    ''';

    final res = await database.rawQuery(query);

    if (res.isNotEmpty) return MonthRegistersSerie.fromMap(res.first);

    return MonthRegistersSerie(DateTime.now(), 0, 0);
  }

  @override
  Future<MonthRegistersSerie> getMonthResume() async {
    final database = await LsDatabase().db;

    final query = '''
      SELECT 
        COALESCE(DATE(${config.salesAggregationDate} / 1000, 'unixepoch', 'start of month', 'localtime'), DATE('now', 'start of month', 'localtime')) AS date,
        COALESCE(SUM(total), 0) AS total,
        COALESCE(SUM(profit), 0) AS profit
      FROM sales
      WHERE DATE(${config.salesAggregationDate} / 1000, 'unixepoch', 'localtime') >= DATE('now', 'start of month', '-12 months', 'localtime')
      GROUP BY date
      ORDER BY date ASC;
    ''';

    final res = await database.rawQuery(query);

    if (res.isNotEmpty) return MonthRegistersSerie.fromMap(res.first);

    return MonthRegistersSerie(DateTime.now(), 0, 0);
  }
}
