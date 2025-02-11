import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class ImportContactPage extends StatefulWidget {
  static const String routeName = 'import_contact_page';

  const ImportContactPage({super.key});

  @override
  State<ImportContactPage> createState() => _ImportContactPageState();
}

class _ImportContactPageState extends State<ImportContactPage> {
  List<Contact> _contacts = [];
  final _fields = ContactField.values.toList();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future _loadContacts() async {
    try {
      if (await Permission.contacts.request().isGranted) {
        _contacts = await FastContacts.getAllContacts(fields: _fields);
        setState(() {});
      }
    } catch (e) {
      print('Erro: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];

          return ListTile(
            title: Text(contact.displayName),
            subtitle: Text(contact.phones.firstOrNull?.number ?? 'Sem Número'),
          );
        },
      ),
    );
  }
}
