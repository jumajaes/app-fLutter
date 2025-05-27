import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/layouts/main.layout.dart';
import 'package:kbox/src/user_data/user_data.dart';
import 'package:kbox/util/colors/hex_color.dart';
import 'package:kbox/util/loadings/page_loading.widget.dart';
import 'package:kbox/util/snackbars/simple_snackbar.widget.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final LatLng _center = const LatLng(6.2442, -75.5812);
  bool _isLoading = true;
  String googleMapId = "";

  @override
  void initState() {
    super.initState();
    _verifyConexion();
  }

  _verifyConexion() async {
    bool hasConexion = await isInternetAvailable();
    if (hasConexion & _verifyMapId()) {
      setState(() {
        _isLoading = false;
      });
    } else {
      _showValidationMessage(
        _verifyMapId() ? "Lo siento, verifica tu conexion de internet" : "Mapa solo disponible para Android e iOS",
        ColorsApp.lightOrange,
        3,
      );

      _goToPorpertiesPage();
    }
  }

  _goToPorpertiesPage() {
    Navigator.of(context).popAndPushNamed("/properties");
  }

  void _showValidationMessage(
    String message,
    HexColor backgroundColor,
    int duration,
  ) {
    SimpleSnackbarWidget.show(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      duration: 8,
    );
  }

  bool _verifyMapId(){
    String mapId = "";
    mapId = Platform.isAndroid ? "394a7446bbfdadcc2c38b828" : "394a7446bbfdadccfb49292f";
    setState(() {
      googleMapId = mapId;
    });
    return mapId.isNotEmpty;
  }

  Future<bool> isInternetAvailable() async {
    try {
      final request = await HttpClient().getUrl(
        Uri.parse('https://www.google.com'),
      );
      final response = await request.close();

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child:
          _isLoading
              ? const PageLoadingWidget()
              : GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 0.0,
                ),
                mapType: MapType.normal,
                cloudMapId: googleMapId,
                markers: Properties.instance.getMarkers(context),
              ),
    );
  }
}
