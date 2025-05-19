import 'package:flutter/material.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/util/strings/strings_helper.dart';

class AppbarAccountWidget extends StatelessWidget {
  final String userName;

  const AppbarAccountWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double verticalPadding =
        (screenSize.height <= 800) ? 0.0 : (screenSize.height * 0.01);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: screenSize.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorsApp.darkGray,
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/online-security.png', height: 40),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: 'Hola ',
                    style: TextStyle(fontSize: 16, color: ColorsApp.text),
                    children: [
                      TextSpan(
                        text: StringsHelper.capitalize(userName),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsApp.text,
                        ),
                      ),
                      TextSpan(
                        text: ", bienvenido a tu\nmundo financiero.",
                        style: TextStyle(
                          color: ColorsApp.text,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: ColorsApp.darkGray,
                  size: 45.0,
                ),
                onPressed: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (_) => ConfigurationsLoginModalWidget(
                  //     onContinue: () {},
                  //     onCancel: () {},
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
