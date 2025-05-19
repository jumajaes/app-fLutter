import 'package:flutter/material.dart';

class SimpleSnackbarWidget {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = const Color(0xFF6AC5DD),
    int duration = 3,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: duration),
      ),
    );
  }
}
