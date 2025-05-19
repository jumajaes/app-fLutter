import 'package:flutter/material.dart';
import 'package:kbox/cards/options_properties_card.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/layouts/main.layout.dart';
import 'package:kbox/util/loadings/page_loading.widget.dart';

class Heritage extends StatefulWidget {
  const Heritage({super.key});

  @override
  State<Heritage> createState() => _HeritageState();
}

class _HeritageState extends State<Heritage> {
  bool _isLoading = true;
  bool _isReload = false;

  late Size _screenSize;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () => {
        setState(() {
          _isLoading = false;
        }),
      },
    );
  }

  void _stopReload() async {
    Future.delayed(
      Duration(seconds: 1),
      () => {
        setState(() {
          _isReload = false;
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return MainLayout(
      child:
          _isLoading
              ? const PageLoadingWidget()
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _isReload
                      ? Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SizedBox(
                          width: _screenSize.width * 0.1,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorsApp.primary,
                            ),
                          ),
                        ),
                      )
                      : Container(),
                  !_isReload
                      ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Patrimonio",
                              style: TextStyle(
                                fontSize: 30,
                                color: ColorsApp.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _screenSize.height * 0.62,
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (scrollNotification) {
                                setState(() {
                                  _isReload = true;
                                });
                                _stopReload();
                                return false;
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    spacing: 15,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: _optionsProperties(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Container(),
                ],
              ),
    );
  }

  List<Widget> _optionsProperties() {
    Widget patrimonio = OptionsPropertiesCard(
      tittle: "Bienes muebles",
      subTittle: "Informacion de tus bienes muebles",
      icon: Icons.home_outlined,
      onPressed: () async => {Navigator.of(context).pushNamed("/map")},
      total: 6100000.00,
    );

    Widget patrimonio2 = OptionsPropertiesCard(
      tittle: "Corporativo",
      subTittle: "Informacion de tus corporativa",
      icon: Icons.work_outline_rounded,
      onPressed: () async => {},
      total: 0,
    );

    Widget patrimonio3 = OptionsPropertiesCard(
      tittle: "Joyas",
      subTittle: "Mira todas tus alajas",
      icon: Icons.diamond_outlined,
      onPressed: () async => {},
      total: 0,
    );

    Widget patrimonio4 = OptionsPropertiesCard(
      tittle: "Arte",
      subTittle: "Obras artisticas",
      icon: Icons.burst_mode_outlined,
      onPressed: () async => {},
      total: 0,
    );
    return [patrimonio, patrimonio2, patrimonio3, patrimonio4];
  }
}
