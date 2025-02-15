import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/components/import_customers_list.dart';
import 'package:lucro_simples/components/import_customers_loading.dart';
import 'package:lucro_simples/components/import_customers_tile.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/pages/import_contacts/success_import_page.dart';
import 'package:lucro_simples/repositories/contacts_repository_interface.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class ImportContactPage extends StatefulWidget {
  static const String routeName = 'import_contact_page';

  const ImportContactPage({super.key});

  @override
  State<ImportContactPage> createState() => _ImportContactPageState();
}

class _ImportContactPageState extends State<ImportContactPage> {
  final customerRepository = getIt.get<ICustomerRepository>();
  final contactsReposiory = getIt.get<IContactsRepository>();

  List<Customer> contacts = [];
  final List<Customer> selecteds = [];
  List<String> phonesAlready = [];

  bool showAppBarTitle = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future _loadContacts() async {
    try {
      isLoading = true;
      setState(() {});

      if (await Permission.contacts.request().isGranted) {
        phonesAlready = await customerRepository.getAllPhones();
        contacts = await contactsReposiory.getAllContacts();
      }
    } catch (e) {
      FeedbackUser.toast(msg: e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Future _import() async {
    for (final customer in selecteds) {
      await customerRepository.registerNewCustomer(customer);
    }

    if (mounted) {
      refreshCustomers.value = true;
      Navigator.pushReplacementNamed(context, SuccessImportPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              const ImportCustomersLoading()
            else
              FadeInUp(
                child: Column(
                  children: [
                    ImportCustomersList(
                      contacts: contacts,
                      onVisibilityHeaderChanged: (info) {
                        final isVisible = info.visibleFraction > 0.01;
                        if (isVisible != !showAppBarTitle) {
                          showAppBarTitle = !isVisible;
                          setState(() {});
                        }
                      },
                      itemBuilder: (customer) => ImportCustomersTile(
                        customer: customer,
                        selected: selecteds.contains(customer),
                        already: phonesAlready.contains(customer.phoneNumber),
                        onChanged: (select) {
                          if (select == true) {
                            selecteds.add(customer);
                          } else {
                            selecteds.remove(customer);
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    PrimaryButton(
                      onPressed: selecteds.isEmpty ? null : _import,
                      margin: const EdgeInsets.all(8),
                      title: 'Importar',
                      iconData: Icons.file_download_outlined,
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: kToolbarHeight,
              child: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: showAppBarTitle ? null : Colors.transparent,
                title: AnimatedOpacity(
                  opacity: showAppBarTitle ? 1 : 0,
                  duration: Durations.medium2,
                  child: const Text('Importação de Contatos'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
