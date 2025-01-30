import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:lucro_simples/utils/formaters_util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesAnimChart extends StatefulWidget {
  const SalesAnimChart({super.key});

  @override
  State<SalesAnimChart> createState() => _SalesAnimChartState();
}

class _SalesAnimChartState extends State<SalesAnimChart> {
  final repository = getIt.get<IAnalyticsRepository>();

  bool isLoading = false;
  List<MonthRegistersSerie> monthSeries = [];
  double total = 0;
  double profit = 0;

  DateTimeRange period = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 6)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _loadData();

    refreshSalesChart.addListener(() {
      if (refreshSalesChart.value) {
        _loadData();
        refreshSalesChart.value = false;
      }
    });
  }

  Future _loadData() async {
    try {
      isLoading = true;
      setState(() {});
      monthSeries = await repository.getByPeriod(period);
      total = monthSeries.fold(0, (s, e) => s + e.total);
      profit = monthSeries.fold(0, (s, e) => s + e.profit);
    } catch (e) {
      if (kDebugMode) print(e);
      FeedbackUser.toast(msg: e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Future _changePeriod() async {
    final newPeriod = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: period,
    );

    if (newPeriod != null) {
      period = newPeriod;
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de Vendas',
                      style: AppTheme.textStyles.caption.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      formatRealBr(total),
                      style: AppTheme.textStyles.titleMedium,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Lucro de ${formatRealBr(profit)} (${getFormatedPercent(profit, total)})',
                        style: AppTheme.textStyles.captionMedium.copyWith(
                          color: AppTheme.colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: _changePeriod,
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: AppTheme.colors.primary.withOpacity(0.08),
                  foregroundColor: AppTheme.colors.primary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month, size: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        getFriendlyPeriod(period),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    const Icon(Icons.swap_horiz, size: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AspectRatio(
            aspectRatio: 2.4,
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 1),
                    ),
                  )
                : SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      shouldAlwaysShow: true,
                      format: 'point.x : point.y',
                    ),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      tooltipAlignment: ChartAlignment.near,
                      tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                      lineColor: AppTheme.colors.stroke,
                      builder: (BuildContext _, TrackballDetails details) {
                        final point = details.point!;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.secondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                point.x,
                                style:
                                    AppTheme.textStyles.captionMedium.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                formatRealBr(point.y?.toDouble() ?? 0),
                                style: AppTheme.textStyles.caption.copyWith(
                                  color: AppTheme.colors.background,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    margin: EdgeInsets.zero,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      arrangeByIndex: true,
                      labelStyle: AppTheme.textStyles.caption.copyWith(
                        color: Colors.black54,
                      ),
                      axisLine: AxisLine(
                        color: AppTheme.colors.stroke,
                        width: 1,
                      ),
                      majorTickLines: const MajorTickLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible: false,
                      numberFormat:
                          NumberFormat.simpleCurrency(locale: 'pt_br'),
                    ),
                    series: [
                      SplineSeries(
                        animationDuration: 2000,
                        dataSource: monthSeries,
                        xValueMapper: (value, _) => getDay(value.date),
                        yValueMapper: (value, _) => value.total,
                        color: AppTheme.colors.primary,
                        enableTooltip: true,
                        name: 'Total do Dia',
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: AppTheme.colors.primary,
                          borderWidth: 2,
                          borderColor: Colors.white,
                        ),
                        width: 2.5,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: AppTheme.textStyles.caption.copyWith(
                            color: AppTheme.colors.primary,
                          ),
                          color: AppTheme.colors.primary,
                          opacity: 0.08,
                          borderRadius: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
