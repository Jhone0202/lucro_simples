import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class FullScreenPage extends StatefulWidget {
  const FullScreenPage({
    super.key,
    required this.images,
    this.initialPage = 0,
  });

  final List<File> images;
  final int initialPage;

  @override
  State<FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  late PageController _pageController;
  int _curretImage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _curretImage = widget.initialPage + 1;
    setState(() {});
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.content,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.colors.content,
        actions: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Text(
              '$_curretImage / ${widget.images.length}',
              style: AppTheme.textStyles.subtitleMedium.copyWith(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (value) => setState(() => _curretImage = value + 1),
        itemCount: widget.images.length,
        itemBuilder: (context, index) => Image.file(
          widget.images[index],
          filterQuality: FilterQuality.none,
        ),
      ),
    );
  }
}
