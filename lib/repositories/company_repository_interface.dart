import 'package:lucro_simples/entities/company.dart';

abstract class ICompanyRepository {
  Future<Company> registerNewCompany(Company company);
}
