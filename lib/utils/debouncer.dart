import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final Duration duration;
  final VoidCallback action;
  Timer? _timer;

  Debouncer({
    required this.action,
    this.duration = Durations.medium2,
  }) {
    run();
  }

  void run() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(duration, action);
  }
}
