import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kbox/modals/confirm_logout_modal.widget.dart';

class Property {
  num? accion;
  String? accionName;
  Map<String, dynamic>? properties;

  Property({this.accion, this.accionName, this.properties});

  Map<String, dynamic> toJson() {
    return {
      'accion': accion,
      'accionName': accionName,
      'properties': properties,
    };
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      accion: json['accion'],
      accionName: json['accionName'],
      properties: json['properties'],
    );
  }
}

class Properties {
  Properties._privateConstructor();

  static final Properties instance = Properties._privateConstructor();

  List<Property> propertiesList = [];

  void addProperty(Property property) {
    propertiesList.add(property);
  }

  List<Property> getProperties() {
    return propertiesList;
  }

  Property? getPropertyByAccion(String accion) {
    return propertiesList.firstWhere(
      (property) => property.accion == accion,
      orElse: () => Property(),
    );
  }

  Set<Marker> getMarkers(BuildContext context) {
    Set<Marker> markers = {};

    for (var property in propertiesList) {
      var accion = property.accion;
      var city = property.properties?['ciudad'] ?? 'Desconocido';
      var location =
          property.properties?['ubicacion'] ?? 'Ubicación no disponible';
      var lat = property.properties?['coordenadas']?['latitud'] ?? 0.0;
      var lng = property.properties?['coordenadas']?['longitud'] ?? 0.0;
      var buyDate = property.properties?['fecha_compra'] ?? '01-01-1900';
      var cost = (property.properties?['valor'] ?? 0.0) as double;

      markers.add(
        Marker(
          markerId: MarkerId("$accion"),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: "$city",
            snippet: location,
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => ConfirmLogoutModalWidget(
                      key: Key(city),
                      name: city,
                      address: location,
                      cost: cost,
                      country: city,
                      buyDate: buyDate,
                      docs: 'Escrituras publicas',
                    ),
              );
            },
          ),
        ),
      );
    }

    return markers;
  }
}
