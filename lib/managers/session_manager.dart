import 'package:lucro_simples/entities/company.dart';

class SessionManager {
  static Company? _company;

  static Company? get loggedCompany => _company;

  static Future initSession(Company company) async {
    _company = company;
  }
}
