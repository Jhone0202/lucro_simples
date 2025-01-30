import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/customer_card.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/helpers/adaptive_grid_helper.dart';
import 'package:lucro_simples/pages/registers/customer_register_page.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';
import 'package:lucro_simples/utils/debouncer.dart';
import 'package:lucro_simples/utils/input_decorations.dart';

class CustomersPage extends StatefulWidget {
  static const String routeName = 'customers_page';

  final bool getCustomer;
  const CustomersPage({super.key, this.getCustomer = false});

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
      appBar: widget.getCustomer
          ? AppBar(title: const Text('Selecione o Cliente'))
          : null,
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
                    minSizeItem: 320,
                    itemCount: customers.length,
                    itemBuilder: (context, index) => CustomerCard(
                      customer: customers[index],
                      onTap: () {
                        if (widget.getCustomer) {
                          Navigator.pop(context, customers[index]);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registerNewCustomer,
        label: const Text('Cadastrar Cliente'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
