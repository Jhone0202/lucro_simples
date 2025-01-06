import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AdaptiveGridHelper extends StatelessWidget {
  const AdaptiveGridHelper({
    super.key,
    this.padding,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.shrinkWrap = false,
    this.physics,
    this.itemCount,
    required this.itemBuilder,
    this.scrollController,
    required this.minSizeItem,
  });

  final EdgeInsets? padding;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int? itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? scrollController;
  final int minSizeItem;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final coluns = (width / minSizeItem).round();

    return MasonryGridView.count(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      crossAxisCount: coluns,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      controller: scrollController,
    );
  }
}
