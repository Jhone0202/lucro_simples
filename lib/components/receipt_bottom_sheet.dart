import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/components/primary_button.dart';
import 'package:lucro_simples/components/receipt.dart';
import 'package:lucro_simples/components/secondary_button.dart';
import 'package:lucro_simples/entities/sale.dart';
import 'package:lucro_simples/helpers/directory_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

showReceipt(BuildContext context, Sale sale, [Function? then]) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ReceiptBottomSheet(sale: sale),
    isScrollControlled: true,
    useSafeArea: true,
  ).then((_) {
    if (then != null) then();
  });
}

class ReceiptBottomSheet extends StatelessWidget {
  const ReceiptBottomSheet({super.key, required this.sale});

  final Sale sale;

  Future _shareReceipt(Sale sale) async {
    final screenshotController = ScreenshotController();

    final capturedImage = await screenshotController.captureFromWidget(
      Receipt(sale: sale),
    );

    final directory = await DirectoryHelper.getTempPath();
    final file = File(
      '${directory.path}/${sale.id}.png',
    );
    await file.writeAsBytes(capturedImage);

    Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade300,
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Receipt(sale: sale),
            ),
          ),
          const SizedBox(height: 8),
          SecondaryButton(
            onPressed: () => _shareReceipt(sale),
            title: 'Enviar Comprovante',
            iconData: Icons.share,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          PrimaryButton(
            onPressed: () => Navigator.pop(context),
            title: 'Voltar ao Início',
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ),
    );
  }
}
