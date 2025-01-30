import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class TodaySalesCard extends StatefulWidget {
  const TodaySalesCard({super.key});

  @override
  State<TodaySalesCard> createState() => _TodaySalesCardState();
}

class _TodaySalesCardState extends State<TodaySalesCard> {
  final repository = getIt.get<IAnalyticsRepository>();

  bool isLoading = false;
  MonthRegistersSerie todayResume = MonthRegistersSerie(DateTime.now(), 0, 0);

  @override
  void initState() {
    super.initState();
    _loadData();

    refreshTodayCard.addListener(() {
      if (refreshTodayCard.value) {
        _loadData();
        refreshTodayCard.value = false;
      }
    });
  }

  Future _loadData() async {
    try {
      isLoading = true;
      setState(() {});
      todayResume = await repository.getTodayResume();
    } catch (e) {
      if (kDebugMode) print('today $e');
      FeedbackUser.toast(msg: e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.colors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total do Dia',
            style: AppTheme.textStyles.caption.copyWith(
              color: Colors.white70,
            ),
          ),
          Text(
            formatRealBr(todayResume.total),
            style: AppTheme.textStyles.titleSmall.copyWith(
              color: AppTheme.colors.background,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppTheme.colors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Lucro de ${formatRealBr(todayResume.profit)} (${getFormatedPercent(todayResume.profit, todayResume.total)})',
              style: AppTheme.textStyles.captionMedium.copyWith(
                color: AppTheme.colors.background,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
