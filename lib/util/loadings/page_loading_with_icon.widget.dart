import 'package:flutter/material.dart';
import 'package:kbox/config/config.dart';

class PageLoadingWithIcon extends StatelessWidget {
  const PageLoadingWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorsApp.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.admin_panel_settings_sharp, size: 300, color: ColorsApp.darkGray,),
          ),
        ],
      ),
    );
  }
}
