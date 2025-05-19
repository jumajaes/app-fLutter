import 'package:flutter/cupertino.dart';
import 'package:kbox/config/config.dart';

class ColorRole {
  static Color colorIcon(String role) {
    final roleColorMap = {
      'Colaborador': ColorsApp.user,
      'Líder': ColorsApp.leader,
      'Coordinador': ColorsApp.coordinator,
      'Administrador': ColorsApp.admin,
      'Super Administrador': ColorsApp.superadmin,
      'Talento Humano': ColorsApp.humantalent,
    };

    return roleColorMap[role] ?? ColorsApp.dimGray;
  }
}
