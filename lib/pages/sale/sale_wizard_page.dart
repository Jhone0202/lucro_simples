import 'package:flutter/material.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/dashboard_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/sale/new_sale_page.dart';
import 'package:lucro_simples/pages/sale/sale_item_page.dart';

class SaleWizardPage extends StatefulWidget {
  static const String routeName = 'sale_wizard_page';

  const SaleWizardPage({super.key});

  @override
  State<SaleWizardPage> createState() => _SaleWizardPageState();
}

class _SaleWizardPageState extends State<SaleWizardPage> {
  final PageController _pageController = PageController();
  final SaleProgress _saleProgress = SaleProgress();
  int _currentStep = 0;

  final List<String> _stepTitles = [
    'Selecione um Cliente',
    'Selecione um Produto',
    'Adicionar à Venda',
  ];

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finalizeSale();
    }
  }

  void _previousStep() {
    if (_currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future _finalizeSale() async {
    final newSale = await Navigator.pushNamed(
      context,
      NewSalePage.routeName,
      arguments: NewSalePageArgs(
        items: [_saleProgress.item!],
        customer: _saleProgress.customer!,
      ),
    ) as Sale?;

    if (newSale != null && mounted) {
      Navigator.pop(context, newSale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep == 0) {
          Navigator.pop(context);
          return false;
        } else {
          _previousStep();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_stepTitles[_currentStep]),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _previousStep,
          ),
        ),
        body: Column(
          children: [
            LinearProgressIndicator(value: (_currentStep + 1) / 3),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CustomersPage(
                    onSelected: (customer) {
                      setState(() => _saleProgress.customer = customer);
                      _nextStep();
                    },
                  ),
                  ProductsPage(
                    onSelected: (product) {
                      setState(() => _saleProgress.product = product);
                      _nextStep();
                    },
                  ),
                  if (_saleProgress.product != null)
                    SaleItemPage(
                      args: SaleItemArgs(
                        product: _saleProgress.product!,
                        onAddItem: (item) {
                          setState(() => _saleProgress.item = item);
                          _nextStep();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
