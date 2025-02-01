import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/entities/month_registers_serie.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';
import 'package:lucro_simples/themes/app_theme.dart';
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
      margin: const EdgeInsets.only(right: 4),
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
            style: AppTheme.textStyles.caption.copyWith(
              color: Colors.black54,
            ),
          ),
          Text(
            formatRealBr(todayResume.total),
            style: AppTheme.textStyles.titleSmall,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppTheme.colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Lucro de ${formatRealBr(todayResume.profit)} (${getFormatedPercent(todayResume.profit, todayResume.total)})',
              style: AppTheme.textStyles.captionMedium.copyWith(
                color: AppTheme.colors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
