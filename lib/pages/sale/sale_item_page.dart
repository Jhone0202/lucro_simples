import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucro_simples/components/edit_quantity_widget.dart';
import 'package:lucro_simples/components/sale_button.dart';
import 'package:lucro_simples/entities/product.dart';
import 'package:lucro_simples/entities/sale_item.dart';
import 'package:lucro_simples/pages/full_screem_page.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:lucro_simples/utils/formaters_util.dart';
import 'package:provider/provider.dart';

class SaleItemArgs {
  final Product product;
  final Function(SaleItem) onAddItem;

  SaleItemArgs({required this.product, required this.onAddItem});
}

class SaleItemPage extends StatefulWidget {
  static const String routeName = 'sale_item_page';

  final SaleItemArgs args;
  const SaleItemPage({super.key, required this.args});

  @override
  State<SaleItemPage> createState() => _SaleItemPageState();
}

class _SaleItemPageState extends State<SaleItemPage> {
  late SaleItem saleItem;

  @override
  void initState() {
    super.initState();
    saleItem = SaleItem(
      productId: widget.args.product.id!,
      productName: widget.args.product.name,
      productPhotoURL: widget.args.product.photoURL,
      productCostPrice: widget.args.product.costPrice,
      quantity: 1,
      productPrice: widget.args.product.salePrice,
      total: widget.args.product.salePrice,
      profit: widget.args.product.salePrice - widget.args.product.costPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SaleItem>.value(
      value: saleItem,
      child: Consumer<SaleItem>(
        builder: (context, saleItem, _) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                          child: widget.args.product.photoURL != null
                              ? InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenPage(
                                        images: [
                                          File(widget.args.product.photoURL!),
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: Image.file(
                                    File(widget.args.product.photoURL!),
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                  ),
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
                              widget.args.product.name,
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyles.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatRealBr(widget.args.product.costPrice),
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyles.titleSmall,
                            ),
                            Text(
                              'Preço de Custo',
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyles.caption.copyWith(
                                color: Colors.black54,
                              ),
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
                            style: AppTheme.textStyles.titleSmall,
                          ),
                          Text(
                            'Preço de Venda',
                            textAlign: TextAlign.center,
                            style: AppTheme.textStyles.caption.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: EditQuantityWidget(
                        remove: saleItem.removeQuantity,
                        add: saleItem.addQuantity,
                        edit: saleItem.editQuantity,
                        quantity: saleItem.quantity,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SaleButton(
                    onPressed: () => widget.args.onAddItem(saleItem),
                    title: 'Adicionar Item',
                    total: saleItem.total,
                    iconData: Icons.add_shopping_cart_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
