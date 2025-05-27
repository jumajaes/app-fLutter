import 'package:flutter/material.dart';
import 'package:kbox/cards/options_home_card.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/layouts/main.layout.dart';
import 'package:kbox/util/loadings/page_loading.widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  _stopReload(ScrollNotification scrollNotification) {
    double realPosition = scrollNotification.metrics.pixels;
    double topPosition = scrollNotification.metrics.minScrollExtent;

    bool hasChanged = scrollNotification is ScrollUpdateNotification;
    bool isTopPosition = realPosition == topPosition;

    bool scrollPpal = scrollNotification.depth == 0;

    if (isTopPosition && hasChanged && scrollPpal) {
      setState(() {
        _isReload = true;
      });
      Future.delayed(
        Duration(seconds: 1),
        () => {
          setState(() {
            _isReload = false;
          }),
        },
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) => {},
      child: MainLayout(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Administracion", style: TextStyle(fontSize: 30, color: ColorsApp.primary, fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(
                              height: _screenSize.height * 0.65,
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  return _stopReload(scrollNotification);
                                },
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GridView(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20,
                                                mainAxisExtent:
                                                    _screenSize.height * 0.3,
                                                mainAxisSpacing: 20,
                                              ),
                                          primary: false,
                                          children: _optionHome(),
                                        ),
                                      ],
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
      ),
    );
  }

  List<Widget> _optionHome() {
    Widget heritage = OptionsHomeCard(
      tittle: "Patrimonio",
      subTittle: "Revisa tus bienes",
      icon: Icons.home_work_outlined,
      onPressed: () => {Navigator.of(context).pushNamed("/properties")},
    );

    Widget team = OptionsHomeCard(
      tittle: "Equipo",
      subTittle: "Administra tu equipo",
      icon: Icons.groups_3_outlined,
      onPressed: () => {},
    );

    Widget keys = OptionsHomeCard(
      tittle: "Llaves",
      subTittle: "Gestiona tus llaves de seguridad y transacciones",
      icon: Icons.vpn_key_outlined,
      onPressed: () => {},
    );

     Widget commands = OptionsHomeCard(
      tittle: "Comandos",
      subTittle: "Ejecuta comandos de voz",
      icon: Icons.mic_none_sharp,
      onPressed: () => {Navigator.of(context).pushNamed("/stt")},
    );

    return [heritage, team, keys, commands];
  }
}
