import 'package:flutter/material.dart';

enum Roles {
  user,
  leader,
  coordinator,
  admin,
  sa,
  th,
}

final Map<String, String> rolesMap = {
  'User': 'Colaborador',
  'Leader': 'Líder',
  'Coordinator': 'Coordinador',
  'Admin': 'Administrador',
  'SA': 'Super Administrador',
  'TH': 'Talento Humano',
};

final Map<Roles, List<Widget>> optionsByRol = {
  Roles.user: [],
  Roles.leader: [],
  Roles.coordinator: [],
  Roles.admin: [],
  Roles.sa: [],
  Roles.th: [],
};
