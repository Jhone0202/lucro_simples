import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final repository = getIt.get<ICustomerRepository>();
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    repository.getPaginatedCustomers('', 100, 0).then((res) {
      customers = res;
      print(customers.length);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: customers.length,
        itemBuilder: (context, index) => Container(
          child: Column(
            children: [
              Text(customers[index].name),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Cadastrar Cliente'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
