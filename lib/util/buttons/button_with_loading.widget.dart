import 'package:flutter/material.dart';

class ButtonWithLoadingWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double fontSize;
  final double padding;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color loaderColor;
  final FontWeight fontWeight;

  const ButtonWithLoadingWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.fontSize = 20,
    this.padding = 0,
    this.borderRadius = 25,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.loaderColor = Colors.white,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isLoading && onPressed != null ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: padding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: loaderColor,
                    strokeWidth: 2,
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
    );
  }
}
