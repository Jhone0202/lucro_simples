import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;

  ConfigService._internal();

  late String salesAggregationDate;

  Future loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    salesAggregationDate =
        prefs.getString('salesAggregationDate') ?? 'saleDate';
  }

  Future setSalesAggregationDate(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('salesAggregationDate', value);
    salesAggregationDate = value;
  }

  Future clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
