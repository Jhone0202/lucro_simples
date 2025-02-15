import 'package:get_it/get_it.dart';
import 'package:lucro_simples/repositories/analytics_repository_interface.dart';
import 'package:lucro_simples/repositories/analytics_repository_sqlite.dart';
import 'package:lucro_simples/repositories/company_repository_interface.dart';
import 'package:lucro_simples/repositories/company_repository_sqlite.dart';
import 'package:lucro_simples/repositories/contacts_repository_fast.dart';
import 'package:lucro_simples/repositories/contacts_repository_interface.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';
import 'package:lucro_simples/repositories/customer_repository_sqlite.dart';
import 'package:lucro_simples/repositories/product_repository_interface.dart';
import 'package:lucro_simples/repositories/product_repository_sqlite.dart';
import 'package:lucro_simples/repositories/sale_repository_interface.dart';
import 'package:lucro_simples/repositories/sale_repository_sqlite.dart';

final getIt = GetIt.instance;

void appInjectorSetup() {
  getIt.registerLazySingleton<ICompanyRepository>(
    () => CompanyRepositorySqlite(),
  );

  getIt.registerLazySingleton<ICustomerRepository>(
    () => CustomerRepositorySqlite(),
  );

  getIt.registerLazySingleton<IProductRepository>(
    () => ProductRepositorySqlite(),
  );

  getIt.registerLazySingleton<ISaleRepository>(
    () => SaleRepositorySqlite(),
  );

  getIt.registerLazySingleton<IAnalyticsRepository>(
    () => AnalyticsRepositorySqlite(),
  );

  getIt.registerLazySingleton<IContactsRepository>(
    () => ContactsRepositoryFast(),
  );
}
