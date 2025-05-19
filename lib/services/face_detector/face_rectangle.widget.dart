import 'package:flutter/material.dart';

class FaceRectangleWidget extends StatelessWidget {
  final Widget rectangle;

  const FaceRectangleWidget({
    super.key,
    required this.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      height: size.height,
      child: rectangle,
    );
  }
}
