import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/app_notifiers.dart';
import 'package:lucro_simples/components/customer_card.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/helpers/adaptive_grid_helper.dart';
import 'package:lucro_simples/pages/registers/customer_register_page.dart';
import 'package:lucro_simples/pages/import_contacts/import_contact_page.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';
import 'package:lucro_simples/utils/debouncer.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

class CustomersPage extends StatefulWidget {
  static const String routeName = 'customers_page';

  final Function(Customer)? onSelected;

  const CustomersPage({super.key, this.onSelected});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final repository = getIt.get<ICustomerRepository>();
  final searchController = TextEditingController();
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();

    refreshCustomers.addListener(() {
      if (refreshCustomers.value) {
        _loadCustomers();
        refreshCustomers.value = false;
      }
    });
  }

  void _loadCustomers() {
    repository.getPaginatedCustomers(searchController.text, 100, 0).then((res) {
      customers = res;
      setState(() {});
    });
  }

  Future _registerNewCustomer() async {
    final newCustomer = await Navigator.pushNamed(
      context,
      CustomerRegisterPage.routeName,
    ) as Customer?;

    if (newCustomer != null) {
      customers.insert(0, newCustomer);
      setState(() {});
    }
  }

  Future _editCustomer(Customer customer, int index) async {
    final newCustomer = await Navigator.pushNamed(
      context,
      CustomerRegisterPage.routeName,
      arguments: customer,
    ) as Customer?;

    if (newCustomer != null) {
      customers[index] = newCustomer;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadCustomers(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => Debouncer(action: _loadCustomers),
                  decoration: defaultFormDecoration(context).copyWith(
                    labelText: 'Pesquisar Cliente',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: FadeInUp(
                  child: AdaptiveGridHelper(
                    minSizeItem: 200,
                    itemCount: customers.length,
                    itemBuilder: (context, index) => CustomerCard(
                      customer: customers[index],
                      onTap: () {
                        if (widget.onSelected != null) {
                          widget.onSelected!(customers[index]);
                        } else {
                          _editCustomer(customers[index], index);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, ImportContactPage.routeName);
            },
            child: Icon(Icons.file_download_outlined),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.extended(
            onPressed: _registerNewCustomer,
            label: const Text('Cadastrar Cliente'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
