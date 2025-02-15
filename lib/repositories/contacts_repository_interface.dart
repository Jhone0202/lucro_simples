import 'package:lucro_simples/entities/customer.dart';

abstract class IContactsRepository {
  Future<List<Customer>> getAllContacts();
}
