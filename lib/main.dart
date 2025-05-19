import 'package:flutter/material.dart';
import 'package:kbox/routes/routes.dart';
import 'package:kbox/src/cam_init.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kbox Demo',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
      routes: AppRoutes.routes,
      home: CamInit(canInit: true),
    );
  }
}