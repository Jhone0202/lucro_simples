import 'package:flutter/material.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/pages/registers/customer_register_page.dart';
import 'package:lucro_simples/pages/home/customers_page.dart';
import 'package:lucro_simples/pages/home/home_page.dart';
import 'package:lucro_simples/pages/home/products_page.dart';
import 'package:lucro_simples/pages/onboarding/onboarding_page.dart';
import 'package:lucro_simples/pages/sale/new_sale_page.dart';
import 'package:lucro_simples/pages/registers/product_register_page.dart';
import 'package:lucro_simples/pages/sale/sale_details_page.dart';
import 'package:lucro_simples/pages/sale/sale_item_page.dart';
import 'package:lucro_simples/pages/splash_page.dart';

final appRoutes = <String, WidgetBuilder>{
  SplashPage.routeName: (context) => const SplashPage(),
  OnboardingPage.routeName: (context) => const OnboardingPage(),
  HomePage.routeName: (context) => const HomePage(),
  ProductsPage.routeName: (context) => ProductsPage(
        getProduct:
            ModalRoute.of(context)?.settings.arguments as bool? ?? false,
      ),
  CustomersPage.routeName: (context) => CustomersPage(
        getCustomer:
            ModalRoute.of(context)?.settings.arguments as bool? ?? false,
      ),
  NewSalePage.routeName: (context) => NewSalePage(
        args: ModalRoute.of(context)?.settings.arguments as NewSalePageArgs,
      ),
  SaleItemPage.routeName: (context) => SaleItemPage(
        product: ModalRoute.of(context)?.settings.arguments as Product,
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
};
