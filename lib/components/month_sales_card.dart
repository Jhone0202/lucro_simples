import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class MonthSalesCard extends StatefulWidget {
  const MonthSalesCard({super.key});

  @override
  State<MonthSalesCard> createState() => _MonthSalesCardState();
}

class _MonthSalesCardState extends State<MonthSalesCard> {
  final repository = getIt.get<IAnalyticsRepository>();

  bool isLoading = false;
  MonthRegistersSerie todayResume = MonthRegistersSerie(DateTime.now(), 0, 0);

  @override
  void initState() {
    super.initState();
    _loadData();

    refreshMonthCard.addListener(() {
      if (refreshMonthCard.value) {
        _loadData();
        refreshMonthCard.value = false;
      }
    });
  }

  Future _loadData() async {
    try {
      isLoading = true;
      setState(() {});
      todayResume = await repository.getMonthResume();
    } catch (e) {
      if (kDebugMode) print(e);
      FeedbackUser.toast(msg: e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total do Mês',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            formatRealBr(todayResume.total),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Lucro de ${formatRealBr(todayResume.profit)} (${getPercent(todayResume.profit, todayResume.total)})',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.green,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
