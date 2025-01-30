import 'package:flutter/material.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';

abstract class IAnalyticsRepository {
  Future<List<MonthRegistersSerie>> getByPeriod(DateTimeRange period);
  Future<MonthRegistersSerie> getTodayResume();
  Future<MonthRegistersSerie> getMonthResume();
}
