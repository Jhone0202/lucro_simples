import 'dart:io';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/customer_types.dart';
import 'package:lucro_simples/repositories/contacts_repository_interface.dart';
import 'package:lucro_simples/utils/masks.dart';
import 'package:path_provider/path_provider.dart';

class ContactsRepositoryFast implements IContactsRepository {
  @override
  Future<List<Customer>> getAllContacts() async {
    final Map<String, String?> imgs = {};

    final contacts = await FastContacts.getAllContacts(
      fields: ContactField.values.toList(),
    );

    final dir = await getApplicationDocumentsDirectory();

    for (var contact in contacts) {
      final memoryImg = await FastContacts.getContactImage(contact.id);

      if (memoryImg != null) {
        final imagePath = '${dir.path}/contact_${contact.id}.png';
        final file = File(imagePath);
        await file.writeAsBytes(memoryImg);
        imgs[contact.id] = file.path;
      }
    }

    List<Customer> customers = [];

    for (final contact in contacts) {
      String rawPhoneNumber = contact.phones.firstOrNull?.number ?? '';
      String formattedPhoneNumber = _formatPhoneNumber(rawPhoneNumber);

      if (rawPhoneNumber.isNotEmpty && contact.displayName.isNotEmpty) {
        customers.add(
          Customer(
            photoURL: imgs[contact.id],
            name: contact.displayName,
            phoneNumber: formattedPhoneNumber,
            type: IndividualCustomer(),
          ),
        );
      }
    }

    return customers;
  }

  String _formatPhoneNumber(String number) {
    if (number.isEmpty) return number;

    final mask = phoneMask;
    mask.updateText(number);
    return mask.text;
  }
}
