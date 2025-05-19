import 'package:kbox/util/colors/hex_color.dart';

class ColorsApp {
  static final HexColor primary = HexColor('6ac5dd');
  static final HexColor secondary = HexColor('f2f2f2');
  static final HexColor tertiary = HexColor('fbc63c');
  static final HexColor lightGray = HexColor('f3edf7');
  static final HexColor dimGray = HexColor('e6e6e6');
  static final HexColor darkGray = HexColor('666666');
  static final HexColor orange = HexColor('fec640');
  static final HexColor yellow = HexColor('ffd301');
  static final HexColor white = HexColor('fffefe');
  static final HexColor warn = HexColor('ef5500');
  static final HexColor blue = HexColor('0097af');
  static final HexColor darkGrayCalendar = HexColor('303030');
  static final HexColor darkGrayDayCalendar = HexColor('a1a1a1');
  static final HexColor lightGrayCalendar = HexColor('dfdfdf');
  static final HexColor lightGrayManagementExceptions = HexColor('b1b1b1');
  static final HexColor seafoam = HexColor('03ffaf');
  static final HexColor violet = HexColor('5c61a3');
  static final HexColor sand = HexColor('ffeb8c');
  static final HexColor lightOrange = HexColor('ff9d27');
  static final HexColor black = HexColor('000000');
  static final HexColor lightGrayHelpLogin = HexColor('e3e3e3');
  static final HexColor darkGrayHelpLogin = HexColor('252525');
  static final HexColor darkOrangeShifts = HexColor('ff4700');
  static final HexColor grayHeaderTablesShifts = HexColor('d9d9d9');
  static final HexColor yellowShifts = HexColor('fedd49');
  static final HexColor shadow = HexColor('ebebeb');
  static final HexColor text = HexColor('595959');
  static final HexColor error = HexColor('3bc4ff');
  static final HexColor textHandle = HexColor('8c8c8c');
  static final HexColor boxInformation = HexColor('f2f2f2');
  static final HexColor started = HexColor('10E310');
  static final HexColor waiting = HexColor('FF0000');
  static final HexColor lateState = HexColor('FF9D27');
  static final HexColor absence = HexColor('FFE760');
  static final HexColor finished = HexColor('666666');
  static final HexColor breaks = HexColor('6AC5DD');
  static final HexColor workExecutedHours = HexColor('FFDA9E');
  static final HexColor workProgramHours = HexColor('FABFB7');
  static final HexColor user = HexColor('6AC5ED');
  static final HexColor leader = HexColor('EEA031');
  static final HexColor coordinator = HexColor('5C61A3');
  static final HexColor superadmin = HexColor('03FFAF');
  static final HexColor admin = HexColor('FFEB8C');
  static final HexColor humantalent = HexColor('FDDC48');
}

class MessagesApp {
  static Map session = {
    'userAuthenticated': 'Inicio de sesión exitoso',
    'incorrectCredentials': 'Usuario o contraseña incorrectos',
    'invalidCredentials': 'Usuario no autorizado en la plataforma',
    'invalidAssignment':
        'No puedes ingresar a la plataforma porque no tienes Áreas/Equipos de trabajo asignadas',
    'accessError': 'Ocurrió un error inesperado. Inténtalo mas tarde',
    'invalidRole': 'Usuario no autorizado' 
  };
  static Map manageWorkshiftValidations = {
    'successfulStart': '¡Tu turno ha sido iniciado correctamente!',
    'successfulEnd': '¡Tu turno ha sido finalizado correctamente!',
    'updateError': 'Ocurrió un error inesperado. Por favor vuelve a intentarlo',
    'invalidGeolocation':
        'La ubicación geográfica no corresponde a la sede donde debes estar o estás muy lejos',
    'invalidFace':
        'El reconocimiento facial no te reconoce, parece que no eres el usuario con el que ingresaste',
    'invalidGeolocationAndInvalidFace':
        'El reconocimiento facial no te reconoce, parece que no eres el usuario con el que ingresaste y la ubicación geográfica no corresponde a la sede donde debes estar o estás muy lejos',
    'reasonRequired': 'Debes escribir un motivo para finalizar el turno',
    'reasonSaved': 'saved reason',
  };
  static Map permissionValidations = {
    'geolocationRequired':
        'Debes aceptar los permisos de localización o activar la ubicación en tu dispositivo para continuar con la solicitud',
  };
  static Map faceIdValidations = {
    'successfulRegister': 'Datos registrados correctamente',
    'errorRegister':
        'Intenta nuevamente el registro, la validación no ha sido exitosa',
  };
  static Map accessPointError = {
    'companyKeyNotFound': 'ERR_KL1290', 
  };
}
