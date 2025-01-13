import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();

    refreshNotifier.addListener(() {
      if (refreshNotifier.value) {
        _loadData();
        refreshNotifier.value = false;
      }
    });
  }

  Future _loadData() async {
    try {
      isLoading = true;
      setState(() {});
      monthSeries = await repository.getLastDaysResume();
      total = monthSeries.fold(0, (s, e) => s + e.total);
      profit = monthSeries.fold(0, (s, e) => s + e.profit);
    } catch (e) {
      FeedbackUser.toast(msg: e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).primaryColor.withOpacity(0.05),
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
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      formatRealBr(total),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Lucro de ${formatRealBr(profit)} (${getPercent(profit, total)})',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.05),
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month, size: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Últimos 7 dias',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    // Icon(Icons.swap_horiz, size: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AspectRatio(
            aspectRatio: 2,
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  )
                : SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    margin: EdgeInsets.zero,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      arrangeByIndex: true,
                      labelStyle: Theme.of(context).textTheme.labelSmall,
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
                        color: Theme.of(context).primaryColor,
                        enableTooltip: true,
                        name: 'Total do Dia',
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: Theme.of(context).primaryColor,
                          borderWidth: 2,
                          borderColor: Colors.white,
                        ),
                        width: 2.5,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: Theme.of(context).textTheme.labelSmall,
                          color: Theme.of(context).primaryColor,
                          opacity: 0.05,
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
