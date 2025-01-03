import 'package:flutter/material.dart';

InputDecoration defaultFormDecoration(BuildContext context) {
  return InputDecoration(
    counterText: '',
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
    floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    focusColor: Theme.of(context).primaryColor,
  );
}
