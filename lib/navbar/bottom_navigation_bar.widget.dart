import 'package:kbox/config/config.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size * 0.2;

    final currentRoute = ModalRoute.of(context)!.settings.name;
    final String currentPage;
    print(currentRoute);

    switch (currentRoute) {
      case '/home':
        currentPage = '1';
        break;
      default:
        currentPage = '0';
        break;
    }

    return Container(
      decoration: BoxDecoration(color: ColorsApp.lightGray),
      width: screenSize.width,
      height:
          (screenSize.height / 0.2) <= 800
              ? (screenSize.height * 0.6)
              : (screenSize.height * 0.53),
      padding: EdgeInsets.only(
        right: screenSize.width * 0.001,
        left: screenSize.width * 0.001,
        top: 2,
        bottom: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navigationOption(
            icon: Image.asset('assets/online-security.png', height: 30),
            label: 'Inicio',
            route: '/home',
            valueCurrent: currentPage,
            value: 1,
            size: screenSize,
            context: context
          ),
        ],
      ),
    );
  }

  Widget _navigationOption({
    required Image icon,
    required String label,
    required String route,
    required String valueCurrent,
    required int value,
    required Size size,
    required BuildContext context,
  }) {
    Color colorIcon = ColorsApp.darkGray;
    if (value.toString() == valueCurrent) {
      colorIcon = ColorsApp.primary;
    }
    return TextButton(
      onPressed: () {
        if (value.toString() != valueCurrent) {
          Navigator.of(context).popAndPushNamed("/home");

        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorIcon,
              fontSize: size.height * 0.09,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class SvgPicture {}
