import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CircleFileImage extends StatelessWidget {
  const CircleFileImage({
    super.key,
    required this.filePath,
    this.size = 56,
  });

  final String? filePath;
  final double size;

  void _showFullScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double fullSize = MediaQuery.of(context).size.width - 100;
        if (fullSize > 300) fullSize = 300;

        return FadeIn(
          child: AlertDialog(
            content: SizedBox(
              width: fullSize,
              height: fullSize,
              child: ClipOval(
                child: Image.file(
                  File(filePath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: filePath != null
            ? InkWell(
                onLongPress: () => _showFullScreen(context),
                child: Image.file(
                  File(filePath!),
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
