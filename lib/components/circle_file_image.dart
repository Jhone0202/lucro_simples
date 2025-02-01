import 'dart:io';
import 'package:flutter/material.dart';

class CircleFileImage extends StatelessWidget {
  const CircleFileImage({
    super.key,
    required this.filePath,
    this.size = 56,
  });

  final String? filePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: filePath != null
            ? Image.file(
                File(filePath!),
                fit: BoxFit.cover,
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
