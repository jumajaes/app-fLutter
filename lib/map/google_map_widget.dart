import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/layouts/main.layout.dart';
import 'package:kbox/modals/confirm_logout_modal.widget.dart';
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

  @override
  void initState() {
    super.initState();
    _verifyConexion();
  }

  _verifyConexion() async {
    bool hasConexion = await isInternetAvailable();
    if (hasConexion) {
      setState(() {
        _isLoading = false;
      });
    } else {
      _showValidationMessage(
        "Lo siento, verifica tu conexion de internet.",
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
                cloudMapId: "394a7446bbfdadcc2c38b828",
                markers: {
                  // Sao Paulo
                  Marker(
                    markerId: MarkerId('Sao Paulo'),
                    position: LatLng(-23.5557714, -46.6395571),
                    infoWindow: InfoWindow(
                      title: "Sao Paulo, Brasil",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("SaoPaulo"),
                                name: "Sao Paulo",
                                address: "Av. Paulista, 1000",
                                cost: 220000.00,
                                country: "Brasil",
                                buyDate: "2025-05-19",
                                docs: "Documento de propiedad",
                              ),
                        );
                      },
                      snippet: "En venta",
                    ),
                  ),

                  // Japón - Tokio
                  Marker(
                    markerId: MarkerId('Tokyo'),
                    position: LatLng(35.6895, 139.6917),
                    infoWindow: InfoWindow(
                      title: "Tokio, Japón",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("Tokyo"),
                                name: "Tokio",
                                address: "Chiyoda City",
                                cost: 350000.00,
                                country: "Japón",
                                buyDate: "2025-05-19",
                                docs: "Certificado de compra",
                              ),
                        );
                      },
                      snippet: "En venta",
                    ),
                  ),

                  // Reino Unido - Londres
                  Marker(
                    markerId: MarkerId('London'),
                    position: LatLng(51.5074, -0.1278),
                    infoWindow: InfoWindow(
                      title: "Londres, Reino Unido",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("London"),
                                name: "Londres",
                                address: "10 Downing St",
                                cost: 230000.00,
                                country: "Reino Unido",
                                buyDate: "2025-05-19",
                                docs: "Soporte de compra",
                              ),
                        );
                      },
                      snippet: "Completo",
                    ),
                  ),

                  // Estados Unidos - Nueva York
                  Marker(
                    markerId: MarkerId('New York'),
                    position: LatLng(40.7128, -74.0060),
                    infoWindow: InfoWindow(
                      title: "Nueva York, EE.UU.",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("NewYork"),
                                name: "Nueva York",
                                address: "5th Avenue",
                                cost: 4000000.00,
                                country: "EE.UU.",
                                buyDate: "2025-05-19",
                                docs: "Validacion de apoderamiento",
                              ),
                        );
                      },
                      snippet: "Reparacion estructural",
                    ),
                  ),

                  // Panamá - Ciudad de Panamá
                  Marker(
                    markerId: MarkerId('Panama City'),
                    position: LatLng(8.9824, -79.5199),
                    infoWindow: InfoWindow(
                      title: "Ciudad de Panamá",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("PanamaCity"),
                                name: "Ciudad de Panamá",
                                address: "Av. Balboa",
                                cost: 200000.00,
                                country: "Panamá",
                                buyDate: "2025-05-19",
                                docs: "Compra venta propiedad",
                              ),
                        );
                      },
                      snippet: "Mejorando pintura",
                    ),
                  ),

                  // Argentina - Buenos Aires
                  Marker(
                    markerId: MarkerId('Buenos Aires'),
                    position: LatLng(-34.6037, -58.3816),
                    infoWindow: InfoWindow(
                      title: "Buenos Aires, Argentina",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("BuenosAires"),
                                name: "Buenos Aires",
                                address: "Av. 9 de Julio",
                                cost: 250000.00,
                                country: "Argentina",
                                buyDate: "2025-05-19",
                                docs: "Titulo de tenencia",
                              ),
                        );
                      },
                      snippet: "En negociación",
                    ),
                  ),

                  // Colombia - Bogotá
                  Marker(
                    markerId: MarkerId('Bogota'),
                    position: LatLng(4.7110, -74.0721),
                    infoWindow: InfoWindow(
                      title: "Bogotá, Colombia",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("Bogota"),
                                name: "Bogotá",
                                address: "Carrera 7",
                                cost: 250000.00,
                                country: "Colombia",
                                buyDate: "2025-05-19",
                                docs: "Escrituras publicas",
                              ),
                        );
                      },
                      snippet: "Completo",
                    ),
                  ),

                  // Colombia - Medellín
                  Marker(
                    markerId: MarkerId('Medellin'),
                    position: LatLng(6.2442, -75.5812),
                    infoWindow: InfoWindow(
                      title: "Medellín, Colombia",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("Medellin"),
                                name: "Medellín",
                                address: "Cra 63B # 42-1",
                                cost: 250000.00,
                                country: "Colombia",
                                buyDate: "2025-05-19",
                                docs: "Escrituras publicas",
                              ),
                        );
                      },
                      snippet: "Completo",
                    ),
                  ),

                  // Colombia - Cali
                  Marker(
                    markerId: MarkerId('Cali'),
                    position: LatLng(3.4516, -76.5320),
                    infoWindow: InfoWindow(
                      title: "Cali, Colombia",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("Cali"),
                                name: "Cali",
                                address: "Calle 5",
                                cost: 300000.00,
                                country: "Colombia",
                                buyDate: "2025-05-19",
                                docs: "Escrituras publicas",
                              ),
                        );
                      },
                      snippet: "En construcción",
                    ),
                  ),

                  // Colombia - Leticia
                  Marker(
                    markerId: MarkerId('Leticia'),
                    position: LatLng(-4.2153, -69.9406),
                    infoWindow: InfoWindow(
                      title: "Leticia, Colombia",
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ConfirmLogoutModalWidget(
                                key: Key("Leticia"),
                                name: "Leticia",
                                address: "Centro Leticia",
                                cost: 100000.00,
                                country: "Colombia",
                                buyDate: "2025-05-19",
                                docs: "Escrituras publicas",
                              ),
                        );
                      },
                      snippet: "En remodelación",
                    ),
                  ),
                },
              ),
    );
  }
}
