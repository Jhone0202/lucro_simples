import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/components/edit_quantity_widget.dart';
import 'package:lucro_simples/components/sale_button.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/utils/feedback_user.dart';
import 'package:lucro_simples/utils/formaters_util.dart';

class SaleItemPage extends StatefulWidget {
  static const String routeName = 'sale_item_page';

  final Product product;
  const SaleItemPage({super.key, required this.product});

  @override
  State<SaleItemPage> createState() => _SaleItemPageState();
}

class _SaleItemPageState extends State<SaleItemPage> {
  late SaleItem saleItem;

  @override
  void initState() {
    super.initState();
    saleItem = SaleItem(
      productId: widget.product.id!,
      productName: widget.product.name,
      productPhotoURL: widget.product.photoURL,
      quantity: 1,
      productPrice: widget.product.salePrice,
      total: widget.product.salePrice,
      profit: widget.product.salePrice - widget.product.costPrice,
    );
  }

  void _addQuantity() {
    saleItem.quantity++;
    _refreshValues();
  }

  void _removeQuantity() {
    if (saleItem.quantity == 1) {
      return FeedbackUser.toast(msg: 'Quantidade mínima permitida');
    }

    saleItem.quantity--;
    _refreshValues();
  }

  void _editQuantity(int newQuantity) {
    saleItem.quantity = newQuantity;
    _refreshValues();
  }

  void _refreshValues() {
    final totalCost = widget.product.costPrice * saleItem.quantity;

    saleItem.total = saleItem.productPrice * saleItem.quantity;
    saleItem.profit = saleItem.total - totalCost;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: widget.product.photoURL != null
                          ? Image.file(
                              File(widget.product.photoURL!),
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                            )
                          : const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.product.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatRealBr(widget.product.costPrice),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Preço de Custo',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        formatRealBr(saleItem.productPrice),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Preço de Venda',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: EditQuantityWidget(
                    remove: _removeQuantity,
                    add: _addQuantity,
                    edit: _editQuantity,
                    quantity: saleItem.quantity,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SaleButton(
                onPressed: () => Navigator.pop(context, saleItem),
                title: 'Adicionar Item',
                total: saleItem.total,
                iconData: Icons.add_shopping_cart_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
