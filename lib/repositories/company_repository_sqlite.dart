import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/repositories/company_repository_interface.dart';

class CompanyRepositorySqlite extends ICompanyRepository {
  @override
  Future<Company> registerNewCompany(Company company) async {
    final database = await LsDatabase().db;

    final existingCompany = await _getCompanyByKey('name', company.name);

    if (existingCompany != null) {
      throw 'Você já cadastrou uma empresa com o nome ${company.name}';
    }

    final id = await database.insert('companies', company.toMap());

    final savedCompany = await _getCompanyByKey('id', id);

    return savedCompany!;
  }

  Future<Company?> _getCompanyByKey(String key, dynamic value) async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'companies',
      where: '$key = ?',
      whereArgs: [value],
    );

    if (res.isEmpty) return null;

    return Company.fromMap(res.first);
  }

  @override
  Future<Company?> getSavedCompany() async {
    final database = await LsDatabase().db;

    final res = await database.query('companies', limit: 1);

    if (res.isEmpty) return null;

    return Company.fromMap(res.first);
  }
}
