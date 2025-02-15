import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucro_simples/components/import_customers_header.dart';
import 'package:lucro_simples/entities/customer.dart';
import 'package:lucro_simples/themes/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ImportCustomersList extends StatefulWidget {
  const ImportCustomersList({
    super.key,
    required this.contacts,
    required this.itemBuilder,
    this.onVisibilityHeaderChanged,
  });

  final List<Customer> contacts;
  final Widget Function(Customer) itemBuilder;
  final Function(VisibilityInfo)? onVisibilityHeaderChanged;

  @override
  State<ImportCustomersList> createState() => _ImportCustomersListState();
}

class _ImportCustomersListState extends State<ImportCustomersList> {
  final scrollController = ScrollController();

  final Map<String, GlobalKey> letterKeys = {};
  late List groupedContacts;
  late List<String> letters;

  String? selectedLetter;
  OverlayEntry? overlayEntry;
  Timer? overlayTimer;

  final containerKey = GlobalKey();
  final overlayOpacity = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _groupContactsByLetter();
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayTimer?.cancel();
    overlayOpacity.dispose();
    super.dispose();
  }

  void _groupContactsByLetter() {
    Map<String, List<Customer>> grouped = {};

    for (var contact in widget.contacts) {
      String letter = contact.name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []).add(contact);
    }

    letters = grouped.keys.toList()..sort();
    groupedContacts = [];

    for (var letter in letters) {
      letterKeys[letter] = GlobalKey();
      groupedContacts.add(letter);
      groupedContacts.addAll(grouped[letter]!);
    }
  }

  void _scrollToLetter(String letter) {
    final key = letterKeys[letter];
    if (key != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Durations.medium2,
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateSelectedLetter(DragUpdateDetails details) {
    final box = containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final localOffset = box.globalToLocal(details.globalPosition);
      final index = (localOffset.dy / 32).clamp(0, letters.length - 1).toInt();
      final letter = letters[index];

      if (selectedLetter != letter) {
        setState(() => selectedLetter = letter);
        _scrollToLetter(letter);
        _showOverlay(letter);
      }
    }
  }

  void _showOverlay(String letter) {
    overlayEntry?.remove();
    overlayOpacity.value = 1.0;

    overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: ValueListenableBuilder<double>(
          valueListenable: overlayOpacity,
          builder: (_, opacity, __) => AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                letter,
                style: AppTheme.textStyles.h1.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);

    overlayTimer?.cancel();
    overlayTimer = Timer(Durations.extralong1, () {
      overlayOpacity.value = 0.0;
      Future.delayed(Durations.short4, () {
        overlayEntry?.remove();
        overlayEntry = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          ListView(
            children: [
              ImportCustomersHeader(
                onVisibilityChanged: widget.onVisibilityHeaderChanged,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                separatorBuilder: (_, index) => const Divider(),
                itemCount: groupedContacts.length,
                itemBuilder: (context, i) {
                  final item = groupedContacts[i];

                  if (item is String) {
                    return Padding(
                      key: letterKeys[item],
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        item,
                        style: AppTheme.textStyles.titleSmall,
                      ),
                    );
                  } else if (item is Customer) {
                    return widget.itemBuilder(item);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          GestureDetector(
            onVerticalDragUpdate: _updateSelectedLetter,
            onVerticalDragEnd: (_) {
              selectedLetter = null;
              setState(() {});
            },
            child: Container(
              key: containerKey,
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.colors.primary.withValues(alpha: 0.1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: letters.map((letter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Text(
                      letter,
                      style: AppTheme.textStyles.captionMedium.copyWith(
                        color: AppTheme.colors.primary,
                        fontWeight: letter == selectedLetter
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
