import 'package:flutter/material.dart';
import 'package:kbox/config/config.dart';

class FacePositionCameraMessageWidget extends StatelessWidget {
  final bool isCorrectPosition;
  final String displayMessage;

  const FacePositionCameraMessageWidget({
    super.key,
    required this.isCorrectPosition,
    required this.displayMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40.0,
      left: 20.0,
      right: 20.0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: isCorrectPosition ? ColorsApp.black : ColorsApp.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            displayMessage,
            style: TextStyle(
              fontSize: 18.0,
              color: !isCorrectPosition ? ColorsApp.black : ColorsApp.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
