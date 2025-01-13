import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';

class AnalyticsRepositorySqlite extends IAnalyticsRepository {
  @override
  Future<List<MonthRegistersSerie>> getLastDaysResume() async {
    final database = await LsDatabase().db;

    const query = '''
      SELECT 
        DATE(saleDate / 1000, 'unixepoch', 'localtime') AS date,
        SUM(total) AS total,
        SUM(profit) AS profit
      FROM sales
      WHERE DATE(saleDate / 1000, 'unixepoch', 'localtime') >= DATE('now', '-7 days', 'localtime')
      GROUP BY date
      ORDER BY date ASC;
    ''';

    final res = await database.rawQuery(query);

    return res.map((e) => MonthRegistersSerie.fromMap(e)).toList();
  }
}
