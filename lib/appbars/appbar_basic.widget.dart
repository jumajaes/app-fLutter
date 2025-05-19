import 'package:flutter/material.dart';
import 'package:kbox/routes/routes.dart';

PreferredSizeWidget appbarBasicWidget({
  bool? backIcon,
  bool? pop,
  BuildContext? context,
}) {
  return AppBar(
    elevation: 2,
    centerTitle: true,
    title: const Image(
      height: 40,
      image: AssetImage("assets/images/kronline_logo.png"),
    ),
    leading: backIcon != null
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              AppRoutes.navigator!.pop();
            },
          )
        : Container(),
  );
}
