import 'package:flutter/material.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/pages/import_contacts/success_import_page.dart';
import 'package:lucro_simples/pages/registers/company_register_page.dart';
import 'package:lucro_simples/pages/registers/customer_register_page.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/home_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/onboarding/onboarding_page.dart';
import 'package:lucro_simples/pages/import_contacts/import_contact_page.dart';
import 'package:lucro_simples/pages/sale/new_sale_page.dart';
import 'package:lucro_simples/pages/registers/product_register_page.dart';
import 'package:lucro_simples/pages/sale/sale_details_page.dart';
import 'package:lucro_simples/pages/sale/sale_item_page.dart';
import 'package:lucro_simples/pages/sale/sale_wizard_page.dart';
import 'package:lucro_simples/pages/splash_page.dart';

final appRoutes = <String, WidgetBuilder>{
  SplashPage.routeName: (context) => const SplashPage(),
  OnboardingPage.routeName: (context) => const OnboardingPage(),
  HomePage.routeName: (context) => const HomePage(),
  ProductsPage.routeName: (context) => ProductsPage(
        onSelected:
            ModalRoute.of(context)?.settings.arguments as Function(Product)?,
      ),
  CustomersPage.routeName: (context) => CustomersPage(
        onSelected:
            ModalRoute.of(context)?.settings.arguments as Function(Customer)?,
      ),
  NewSalePage.routeName: (context) => NewSalePage(
        args: ModalRoute.of(context)?.settings.arguments as NewSalePageArgs,
      ),
  SaleItemPage.routeName: (context) => SaleItemPage(
        args: ModalRoute.of(context)?.settings.arguments as SaleItemArgs,
      ),
  ProductRegisterPage.routeName: (context) => ProductRegisterPage(
        editableProduct: ModalRoute.of(context)?.settings.arguments as Product?,
      ),
  CustomerRegisterPage.routeName: (context) => CustomerRegisterPage(
        editableCustomer:
            ModalRoute.of(context)?.settings.arguments as Customer?,
      ),
  SaleDetailsPage.routeName: (context) => SaleDetailsPage(
        sale: ModalRoute.of(context)?.settings.arguments as Sale,
      ),
  SaleWizardPage.routeName: (context) => SaleWizardPage(
        flowType: ModalRoute.of(context)!.settings.arguments as SaleFlowType,
      ),
  CompanyRegisterPage.routeName: (context) => const CompanyRegisterPage(),
  ImportContactPage.routeName: (context) => const ImportContactPage(),
  SuccessImportPage.routeName: (context) => const SuccessImportPage(),
};
