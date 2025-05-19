import 'package:flutter/material.dart';
import 'package:kbox/map/google_map_widget.dart';
import 'package:kbox/src/home.dart';
import 'package:kbox/src/pages/heritage.dart';

class AppRoutes {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final navigator = navigatorKey.currentState;

  static final routes = {
    '/home': (_) => const Home(),
    '/properties': (_) => const Heritage(),
    '/map': (_) => const GoogleMapWidget(),
  };
}
