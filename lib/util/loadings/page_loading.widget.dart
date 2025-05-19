import 'package:flutter/material.dart';
import 'package:kbox/config/config.dart';

class PageLoadingWidget extends StatelessWidget {
  const PageLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorsApp.primary),
      ),
    );
  }
}
