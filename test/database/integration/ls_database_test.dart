import 'package:flutter_test/flutter_test.dart';
import 'package:lucro_simples/app_mode.dart';
import 'package:lucro_simples/database/ls_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../mocks/ls_database_mock.dart';

void main() {
  late Database database;
  final dataMock = LsDatabaseMock();

  setUpAll(() async {
    AppMode.appmode = APP_MODE.runTest;
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    database = await LsDatabase().db;
  });

  tearDownAll(() async {
    await LsDatabase.closeDatabase();
    await deleteDatabase(database.path);
  });

  test('Register company', () async {
    final company = dataMock.getCompany();
    final res = await database.insert('companies', company.toMap());
    expect(res > 0, true);
  });

  test('Register product', () async {
    final product = dataMock.getProduct();
    final res = await database.insert('products', product.toMap());
    expect(res > 0, true);
  });

  test('Register customer', () async {
    final customer = dataMock.getCustomer();
    final res = await database.insert('customers', customer.toMap());
    expect(res > 0, true);
  });

  test('Register sale', () async {
    final companyId = await database.insert(
      'companies',
      dataMock.getCompany().toMap(),
    );

    final productId = await database.insert(
      'products',
      dataMock.getProduct().toMap(),
    );

    final customerId = await database.insert(
      'customers',
      dataMock.getCustomer().toMap(),
    );

    final sale = dataMock.getSale(
      companyId: companyId,
      productId: productId,
      customerId: customerId,
    );

    final res = await database.insert('sales', sale.toMap());
    expect(res > 0, true);
  });
}
