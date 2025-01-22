import 'package:lucro_simples/entities/company.dart';

abstract class ICompanyRepository {
  Future<Company> saveCompany(Company company);
  Future<Company?> getSavedCompany();
}
