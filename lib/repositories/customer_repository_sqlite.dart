import 'package:lucro_simples/databases/ls_database.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';

class CustomerRepositorySqlite extends ICustomerRepository {
  @override
  Future<Customer> registerNewCustomer(Customer customer) async {
    final database = await LsDatabase().db;

    final existingCustomer = await _getCustomerByKey(
      'phoneNumber',
      customer.phoneNumber,
    );

    if (existingCustomer != null) {
      throw 'Você já cadastrou um cliente com o telefone ${customer.phoneNumber}';
    }

    final id = await database.insert('customers', customer.toMap());

    final savedCustomer = await _getCustomerByKey('id', id);

    return savedCustomer!;
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    if (customer.id == null) throw 'Cliente sem ID informado';

    final database = await LsDatabase().db;

    await database.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );

    final updatedCustomer = await _getCustomerByKey('id', customer.id);

    return updatedCustomer!;
  }

  Future<Customer?> _getCustomerByKey(String key, dynamic value) async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'customers',
      where: '$key = ?',
      whereArgs: [value],
    );

    if (res.isEmpty) return null;

    return Customer.fromMap(res.first);
  }

  @override
  Future<List<Customer>> getPaginatedCustomers(
    String search,
    int? limit,
    int? offset,
  ) async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'customers',
      where: search.isEmpty
          ? null
          : 'name LIKE "%$search%" OR phoneNumber LIKE "%$search%"',
      orderBy: 'name',
      limit: limit,
      offset: offset,
    );

    return res.map((e) => Customer.fromMap(e)).toList();
  }

  @override
  Future<List<String>> getAllPhones() async {
    final database = await LsDatabase().db;

    final res = await database.query(
      'customers',
      columns: ['phoneNumber'],
    );

    return res.map((e) => e['phoneNumber'] as String).toList();
  }
}
