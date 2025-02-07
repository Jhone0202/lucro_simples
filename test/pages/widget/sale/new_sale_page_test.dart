import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/app_injector.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/entities/company.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/managers/session_manager.dart';
import 'package:lucro_simples/pages/sale/new_sale_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../database/mocks/ls_database_mock.dart';
import '../../../entities/mocks/sale_mock.dart';

void main() {
  final saleMock = SaleMock();
  final databaseMock = LsDatabaseMock();

  setUpAll(() async {
    appInjectorSetup();
    SessionManager.initSession(Company(id: 1, name: 'test', userName: 'test'));
  });

  Future pumpSalePage(WidgetTester tester) async {
    final sale = saleMock.simpleSale();
    final customer = databaseMock.getCustomer(id: sale.customerId);
    final args = NewSalePageArgs(items: sale.items, customer: customer);

    await tester.pumpWidget(
      MaterialApp(
        home: ScaffoldMessenger(
          child: ChangeNotifierProvider<Sale>.value(
            value: sale,
            child: NewSalePage(args: args),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets(
    'Ensures the conclude sale button is visible and accessible',
    (WidgetTester tester) async {
      await pumpSalePage(tester);

      final scrollButton = find.byIcon(Icons.arrow_downward);
      if (scrollButton.evaluate().isNotEmpty) {
        await tester.tap(scrollButton);
        await tester.pumpAndSettle();
      }

      final concludeButton = find.widgetWithText(
        PrimaryButton,
        'Concluír Venda',
      );
      await tester.ensureVisible(concludeButton);

      expect(concludeButton, findsOneWidget);
    },
  );
}
