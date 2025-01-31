import 'package:flutter/material.dart';
import 'package:lucro_simples/entities/sale_progess.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/sale/sale_item_page.dart';

enum SaleFlowType { customerSelection, productWithItemSelection, fullFlow }

class SaleWizardPage extends StatefulWidget {
  static const String routeName = 'sale_wizard_page';
  final SaleFlowType flowType;

  const SaleWizardPage({super.key, required this.flowType});

  @override
  State<SaleWizardPage> createState() => _SaleWizardPageState();
}

class _SaleWizardPageState extends State<SaleWizardPage> {
  final PageController pageController = PageController();
  final SaleProgress saleProgress = SaleProgress();
  int currentStep = 0;
  int stepCount = 3;

  final List<String> stepTitles = [
    'Selecione um Cliente',
    'Selecione um Produto',
    'Adicionar à Venda',
  ];

  @override
  void initState() {
    super.initState();

    switch (widget.flowType) {
      case SaleFlowType.customerSelection:
        stepCount = 1;
        break;
      case SaleFlowType.productWithItemSelection:
        stepCount = 2;
        stepTitles.removeAt(0);
        break;
      default:
    }
  }

  void _nextStep() {
    if (widget.flowType == SaleFlowType.customerSelection) {
      _prepareToSale();
    } else {
      if (currentStep < stepCount - 1) {
        setState(() => currentStep++);
        pageController.nextPage(
          duration: Durations.medium2,
          curve: Curves.easeInOut,
        );
      } else {
        _prepareToSale();
      }
    }
  }

  void _previousStep() {
    if (currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() => currentStep--);
      pageController.previousPage(
        duration: Durations.medium2,
        curve: Curves.easeInOut,
      );
    }
  }

  Future _prepareToSale() async {
    Navigator.pop(context, saleProgress);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentStep == 0) {
          Navigator.pop(context);
          return false;
        }
        _previousStep();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(stepTitles[currentStep]),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _previousStep,
          ),
        ),
        body: Column(
          children: [
            LinearProgressIndicator(value: (currentStep + 1) / stepCount),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (widget.flowType != SaleFlowType.productWithItemSelection)
                    CustomersPage(
                      onSelected: (customer) {
                        setState(() => saleProgress.customer = customer);
                        _nextStep();
                      },
                    ),
                  if (widget.flowType != SaleFlowType.customerSelection)
                    ProductsPage(
                      onSelected: (product) {
                        setState(() => saleProgress.product = product);
                        _nextStep();
                      },
                    ),
                  if (widget.flowType != SaleFlowType.customerSelection &&
                      saleProgress.product != null)
                    SaleItemPage(
                      args: SaleItemArgs(
                        product: saleProgress.product!,
                        onAddItem: (item) {
                          setState(() => saleProgress.item = item);
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
