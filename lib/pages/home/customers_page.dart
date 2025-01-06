import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/circle_file_image.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/repositories/customer_repository_interface.dart';

class CustomersPage extends StatefulWidget {
  static const String routeName = 'customers_page';

  final bool getCustomer;
  const CustomersPage({super.key, this.getCustomer = false});

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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.getCustomer
          ? AppBar(title: const Text('Selecione o Cliente'))
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.7,
                ),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (widget.getCustomer) {
                          Navigator.pop(context, customer);
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleFileImage(filePath: customer.photoURL),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    customer.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 12),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    customer.phoneNumber,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
