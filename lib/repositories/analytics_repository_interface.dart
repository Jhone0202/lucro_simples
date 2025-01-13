import 'package:lucro_simples/entities/month_registers_serie.dart';

abstract class IAnalyticsRepository {
  Future<List<MonthRegistersSerie>> getLastDaysResume();
}
