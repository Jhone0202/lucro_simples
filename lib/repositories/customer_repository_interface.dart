import 'package:lucro_simples/entities/customer.dart';

abstract class ICustomerRepository {
  Future<Customer> registerNewCustomer(Customer customer);
  Future<Customer> updateCustomer(Customer customer);
  Future<List<Customer>> getPaginatedCustomers(
    String search,
    int? limit,
    int? offset,
  );
  Future<List<String>> getAllPhones();
}
