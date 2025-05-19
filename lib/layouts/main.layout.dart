import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kbox/appbars/appbar_account.widget.dart';
import 'package:kbox/navbar/bottom_navigation_bar.widget.dart';


class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: 
          PreferredSize(
              preferredSize: Size.fromHeight(screenSize.height * 0.1),
              child: SafeArea(
                child: AppbarAccountWidget(
                  userName: 'Juan',
                ),
              ),
            ),
      body: widget.child,
      bottomNavigationBar:
          BottomNavigationBarWidget(),
    );
  }
}
