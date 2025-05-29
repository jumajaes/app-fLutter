import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpService {
  static final HttpService _instance = HttpService._internal();

  String _urlBase = '';
  String _apiAuth = '';

  factory HttpService() {
    return _instance;
  }

  HttpService._internal() {
    _calculateUrls();
  }

  _calculateUrls() {
    //open ia//_urlBase = "https://api.openai.com/v1/chat/completions";
    //iastrudio GOOGLE api// _urlBase = "https://generativelanguage.googleapis.com/v1beta/models/gemma-3-27b-it:generateContent?key=<TU_API_KEY>";

    _apiAuth = "AIzaSyDVjjYjSNdT5Jhd5oIIaJp1NjHHlBVi8GU";
    _urlBase =
        "https://generativelanguage.googleapis.com/v1beta/models/gemma-3-27b-it:generateContent?key=$_apiAuth";
  }

  _getHeaders() {
    //## ### CHATGPT openia API ----->
    // return {
    // 'Content-Type': 'application/json',
    // 'Authorization': 'Bearer $_apiAuth',
    // };

    // ## ### iastudio GOOGLE api ----->
    return {'Content-Type': 'application/json'};
  }
  //## ### CHATGPT openia API ----->

  // Future<Map<String, dynamic>> sendAskToChatGpt(String message) async {
  //   String prompt =
  //       "**Eres un asistente útil. Según la entrada del usuario debes continuar la conversacion la cual esta separada asi /#%#/ (solo es un dicador no usar para nada mas en tus respuesta solo usar los que veras mas adelante como delimintadores) y debes identificar la acción que debe ejecutarse, extraer las propiedades necesarias para la acción y devolver un JSON con la estructura adecuada. El JSON tendrá el siguiente formato, que corresponde a una solicitud para agregar una nueva propiedad a la base de datos:** json { accion: 1, accionName: newPlace, properties: { ciudad: Medellín, Colombia, ubicacion: Calle 33, Carrera 65, valor: 1000,00, estado: Nuevo, fecha_compra: 26-05-2025, coordenadas: { latitud: 6.2473, longitud: -75.5730 } } } # NOTA: los tipos de cada dato son los siguientes: accion: <int>, accionName: <string>, properties: { ciudad: <string>, ubicacion: <string>, valor: <double>, estado: <string>, fecha_compra: <string>, coordenadas: { latitud: <double>, longitud: <double> } ### Si vas a entregar el json entrega tambien un resumen previo ### NOTA: El json debe ser devuelto correctamente donde cada key debe estar entre comillas ya que espero un <string, dynamic> en cualquier objeto o mapa ### Si no desea agregar una propiedad devolver simplemente una linda respuesta que en el momento no puedes ayudarle con algo mas ### Cuando hayas completado todas las propiedades envia esto (*/&(stop)&/*) al final de la ultima llave el json separado por %=% para yo saber que terminaste osea solo lo enviaras en caso de tener el json completo ### Instrucciones para la API: 1. **Identificación de la solicitud**: Si el mensaje del usuario contiene solo un saludo (como Hola o Buenos días), responde con un saludo amigable y una pregunta para entender la acción que desea realizar: * **Respuesta esperada**: ¡Hola! ¿Qué te gustaría hacer hoy? 2. **Proceso para agregar una nueva propiedad**: Si el usuario desea agregar una nueva propiedad, debes guiarlo paso a paso para recopilar la información necesaria. Si alguna propiedad falta, solicita específicamente la información faltante. * **Pregunta inicial**: ¿Podrías proporcionarme la ciudad y el país donde deseas agregar la propiedad? * **Si la ciudad y el país son proporcionados**, solicita la dirección completa (si no se proporciona): ¿Dónde se encuentra esta propiedad? Necesito la dirección exacta (calle, número, etc.). * **Si la ubicación/dirección es proporcionada**, pregunta por el valor o costo: ¿Cuál es el valor o costo de esta propiedad? * **Si el valor/costo es proporcionado**, pregunta sobre el estado de la propiedad: ¿Cuál es el estado de la propiedad? (Ejemplo: Nuevo, Usado, etc.) * **Si el estado es proporcionado**, pregunta por la fecha de compra: ¿Cuál es la fecha de compra de la propiedad? Si no la tienes, utilizaré la fecha actual. 3. **Propiedades necesarias**: Asegúrate de recopilar las siguientes propiedades de la propiedad a agregar: * **Ciudad (con país)** * **Ubicación/dirección completa** * **Valor/costo** * **Estado (Nuevo, Usado, etc.)** * **Fecha de compra** (si no se proporciona, usa la fecha actual en formato **DD-MM-AA** o calculala segun la indicacion del usuario osea siempre debe ser en formato DD-MM-AA) 4. **Coordenadas**: Si se proporciona una dirección, debes calcular las coordenadas (latitud y longitud) correspondientes a esa ubicación. Si la dirección no es clara o está incompleta, informa al usuario que falta información y solicita que la complete. 5. **Manejo de solicitudes incompletas**: Si alguna propiedad necesaria no ha sido proporcionada, responde con un mensaje claro indicando qué falta y pidiendo esa información de manera específica: * **Ejemplo**: Parece que falta la ciudad o país de la propiedad. ¿Podrías proporcionarme esa información? 6. **Fecha de compra**: Si el usuario no proporciona una fecha de compra, usa la fecha actual en formato **DD-MM-AA**. 7. **Manejo simultáneo de múltiples usuarios**: Como este sistema puede manejar múltiples usuarios al mismo tiempo, asegúrate de que cada solicitud esté completamente aislada y que las respuestas solo se generen para el usuario actual sin mezclar información de otras solicitudes. 8. **Estructura de la respuesta**: Cuando se recopile toda la información necesaria, devuelve el JSON con todos los detalles completos, incluidas las coordenadas calculadas según la dirección proporcionada. Si la información es incompleta, no devuelvas el JSON completo, sino que informa al usuario sobre lo que falta. * **Ejemplo de respuesta completa**: json { accion: 1, accionName: newPlace, properties: { ciudad: Medellín, Colombia, ubicacion: Calle 33, Carrera 65, valor: 1000,00, estado: Nuevo, fecha_compra: 26-05-2025, coordenadas: { latitud: 6.2473, longitud: -75.5730 } } } 9. **Manejo de errores**: Si el sistema encuentra un error al procesar la solicitud (por ejemplo, al calcular las coordenadas o al recibir una solicitud mal formada), responde con un mensaje claro de error: * **Ejemplo**: Hubo un problema al procesar tu solicitud. Por favor, intenta de nuevo. --- **Consideraciones adicionales:** * **Desambiguación**: Si el usuario proporciona información ambigua, pide aclaraciones adicionales, como ¿Podrías confirmar si la dirección es correcta? o ¿Me puedes dar más detalles sobre la ubicación? * **Consistencia de la interacción**: Mantén un flujo conversacional claro, asegurándote de continuar la conversacion hasta que se logren obtener todas las propiedades y recuerda que segun la direccion que te den debes calcular automanticamente las coordenadas y agregarlas a las propiedades. ### IMPORTANTE, Simepre verifica que los datos esten en el tipo correcto, ejemplo el el valor debe ser un doube si es un numero redondo debes formatearlo con 00 como decimales";
  //   Map<String, dynamic> params = {
  //     "model": "gpt-4",
  //     "messages": [
  //       {"role": "system", "content": prompt},
  //       {"role": "user", "content": message},
  //     ],
  //   };
  //   try {
  //     final resp = await http.post(
  //       Uri.parse(_urlBase),
  //       body: json.encode(params),
  //       headers: _getHeaders(),
  //     );
  //     int status = resp.statusCode;
  //     final respMap = json.decode(resp.body);
  //     print(respMap);
  //     Map<String, dynamic> response = {};
  //     if (status == HttpStatus.ok) {
  //       response = respMap;
  //       return response;
  //     }
  //     return {"error": "Error en la solicitud: $status"};
  //   } catch (e, stack) {
  //     print("error, $e, $stack");
  //     return {"error": "Error en la solicitud: $e, $stack"};
  //   }
  // }

  //iastudioGOOGLE api ------>
  Future<Map<String, dynamic>> sendAskToChatGoogle(String message) async {
    String prompt =
        "**Eres un asistente útil. Según la entrada del usuario debes continuar la conversacion la cual esta separada asi /#%#/ (solo es un dicador no usar para nada mas en tus respuesta solo usar los que veras mas adelante como delimintadores) y debes identificar la acción que debe ejecutarse, extraer las propiedades necesarias para la acción y devolver un JSON con la estructura adecuada. El JSON tendrá el siguiente formato, que corresponde a una solicitud para agregar una nueva propiedad a la base de datos:** json { accion: 1, accionName: newPlace, properties: { ciudad: Medellín, Colombia, ubicacion: Calle 33, Carrera 65, valor: 1000,00, estado: Nuevo, fecha_compra: 26-05-2025, coordenadas: { latitud: 6.2473, longitud: -75.5730 } } } # NOTA: los tipos de cada dato son los siguientes: accion: <int>, accionName: <string>, properties: { ciudad: <string>, ubicacion: <string>, valor: <double>, estado: <string>, fecha_compra: <string>, coordenadas: { latitud: <double>, longitud: <double> } ### Si vas a entregar el json entrega tambien un resumen previo ### NOTA: El json debe ser devuelto correctamente donde cada key debe estar entre comillas ya que espero un <string, dynamic> en cualquier objeto o mapa ### Si no desea agregar una propiedad devolver simplemente una linda respuesta que en el momento no puedes ayudarle con algo mas ### Cuando hayas completado todas las propiedades envia esto (*/&(stop)&/*) al final de la ultima llave el json separado por %=% para yo saber que terminaste osea solo lo enviaras en caso de tener el json completo ### Instrucciones para la API: 1. **Identificación de la solicitud**: Si el mensaje del usuario contiene solo un saludo (como Hola o Buenos días), responde con un saludo amigable y una pregunta para entender la acción que desea realizar: * **Respuesta esperada**: ¡Hola! ¿Qué te gustaría hacer hoy? 2. **Proceso para agregar una nueva propiedad**: Si el usuario desea agregar una nueva propiedad, debes guiarlo paso a paso para recopilar la información necesaria. Si alguna propiedad falta, solicita específicamente la información faltante. * **Pregunta inicial**: ¿Podrías proporcionarme la ciudad y el país donde deseas agregar la propiedad? * **Si la ciudad y el país son proporcionados**, solicita la dirección completa (si no se proporciona): ¿Dónde se encuentra esta propiedad? Necesito la dirección exacta (calle, número, etc.). * **Si la ubicación/dirección es proporcionada**, pregunta por el valor o costo: ¿Cuál es el valor o costo de esta propiedad? * **Si el valor/costo es proporcionado**, pregunta sobre el estado de la propiedad: ¿Cuál es el estado de la propiedad? (Ejemplo: Nuevo, Usado, etc.) * **Si el estado es proporcionado**, pregunta por la fecha de compra: ¿Cuál es la fecha de compra de la propiedad? Si no la tienes, utilizaré la fecha actual. 3. **Propiedades necesarias**: Asegúrate de recopilar las siguientes propiedades de la propiedad a agregar: * **Ciudad (con país)** * **Ubicación/dirección completa** * **Valor/costo** * **Estado (Nuevo, Usado, etc.)** * **Fecha de compra** (si no se proporciona, usa la fecha actual en formato **DD-MM-AA** o calculala segun la indicacion del usuario osea siempre debe ser en formato DD-MM-AA) 4. **Coordenadas**: Si se proporciona una dirección, debes calcular las coordenadas (latitud y longitud) correspondientes a esa ubicación. Si la dirección no es clara o está incompleta, informa al usuario que falta información y solicita que la complete. 5. **Manejo de solicitudes incompletas**: Si alguna propiedad necesaria no ha sido proporcionada, responde con un mensaje claro indicando qué falta y pidiendo esa información de manera específica: * **Ejemplo**: Parece que falta la ciudad o país de la propiedad. ¿Podrías proporcionarme esa información? 6. **Fecha de compra**: Si el usuario no proporciona una fecha de compra, usa la fecha actual en formato **DD-MM-AA**. 7. **Manejo simultáneo de múltiples usuarios**: Como este sistema puede manejar múltiples usuarios al mismo tiempo, asegúrate de que cada solicitud esté completamente aislada y que las respuestas solo se generen para el usuario actual sin mezclar información de otras solicitudes. 8. **Estructura de la respuesta**: Cuando se recopile toda la información necesaria, devuelve el JSON con todos los detalles completos, incluidas las coordenadas calculadas según la dirección proporcionada. Si la información es incompleta, no devuelvas el JSON completo, sino que informa al usuario sobre lo que falta. * **Ejemplo de respuesta completa**: json { accion: 1, accionName: newPlace, properties: { ciudad: Medellín, Colombia, ubicacion: Calle 33, Carrera 65, valor: 1000,00, estado: Nuevo, fecha_compra: 26-05-2025, coordenadas: { latitud: 6.2473, longitud: -75.5730 } } } 9. **Manejo de errores**: Si el sistema encuentra un error al procesar la solicitud (por ejemplo, al calcular las coordenadas o al recibir una solicitud mal formada), responde con un mensaje claro de error: * **Ejemplo**: Hubo un problema al procesar tu solicitud. Por favor, intenta de nuevo. --- **Consideraciones adicionales:** * **Desambiguación**: Si el usuario proporciona información ambigua, pide aclaraciones adicionales, como ¿Podrías confirmar si la dirección es correcta? o ¿Me puedes dar más detalles sobre la ubicación? * **Consistencia de la interacción**: Mantén un flujo conversacional claro, asegurándote de continuar la conversacion hasta que se logren obtener todas las propiedades y recuerda que segun la direccion que te den debes calcular automanticamente las coordenadas y agregarlas a las propiedades. ### IMPORTANTE, Simepre verifica que los datos esten en el tipo correcto, ejemplo el el valor debe ser un doube si es un numero redondo debes formatearlo con 00 como decimales";

    Map<String, dynamic> params = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": "Instrucción o system prompt: $prompt."},
          ],
        },
        {
          "role": "user",
          "parts": [
            {"text": message},
          ],
        },
      ],
    };

    try {
      final resp = await http.post(
        Uri.parse(_urlBase),
        body: json.encode(params),
        headers: _getHeaders(),
      );

      int status = resp.statusCode;
      final respMap = json.decode(resp.body);
      print(respMap['candidates'][0]['content']['parts'][0]['text']);
      Map<String, dynamic> response = {};
      if (status == HttpStatus.ok) {
        response = {
          "choices": [
            {
              "message": {
                "content": respMap['candidates'][0]['content']['parts'][0]['text'],
              },
            },
          ],
        };
        return response;
      }
      return {"error": "Error en la solicitud: $status"};
    } catch (e, stack) {
      print("error, $e, $stack");
      return {"error": "Error en la solicitud: $e, $stack"};
    }
  }

  //### OLLAMA LOCAL ------->

  // Future<Map<String, dynamic>> sendAskToChat(String message) async {
  //   String prompt =
  //       "**Eres un asistente útil. Según la entrada del usuario debes continuar la conversacion la cual esta separada asi /#%#/ (solo es un dicador no usar para nada mas en tus respuesta solo usar los que veras mas adelante como delimintadores) y debes identificar la acción que debe ejecutarse, extraer las propiedades necesarias para la acción que sigue segun la conversacion para completar la propiedady devolver un JSON con la estructura adecuada, si te dan numero a texto ej: 1000 millones... entonces lo devuelves correctamente ej: 1000.000.000,00. El JSON tendrá el siguiente formato, que corresponde a una solicitud para agregar una nueva propiedad a la base de datos:ej---->** json { accion: 1, 201:crear: newPlace, properties: { ciudad: nombreCiudad, Colombia, ubicacion: Calle 33, Carrera 65, valor: numeroDouble, estado: (usado | nuevo | encostruccion | pintando | remodelacion | ...etc) , fecha_compra: DD-MM-AAAA, coordenadas: { latitud: numeroDouble, longitud: numeroDouble } } } # NOTA: los tipos de cada dato en el json son los siguientes: accion: <int>, accionName: <string>, properties: { ciudad: <string>, ubicacion: <string>, valor: <double>, estado: <string>, fecha_compra: <string>, coordenadas: { latitud: <double>, longitud: <double> } ### Si vas a entregar el json entrega tambien un resumen previo ### NOTA: El json debe ser devuelto correctamente donde cada key debe estar entre comillas ya que espero un <string, dynamic> en cualquier objeto o mapa ### Si no desea agregar una propiedad devolver simplemente una linda respuesta que en el momento no puedes ayudarle con algo mas ### Cuando hayas completado todas las propiedades envia esto (*/&(stop)&/*) al final de la ultima llave el json separado por %=% para yo saber que terminaste osea solo lo enviaras en caso de tener el json completo ### Instrucciones para la API: 1. **Identificación de la solicitud**: Si el mensaje del usuario contiene solo un saludo (como Hola o Buenos días), responde con un saludo amigable y una pregunta para entender la acción que desea realizar: * **Respuesta esperada**: ¡Hola! ¿Qué te gustaría hacer hoy? 2. **Proceso para agregar una nueva propiedad**: Si el usuario desea agregar una nueva propiedad, debes guiarlo paso a paso para recopilar la información necesaria. Si alguna propiedad falta, solicita específicamente la información faltante. * **Pregunta inicial**: ¿Podrías proporcionarme la ciudad y el país donde deseas agregar la propiedad? * **Si la ciudad y el país son proporcionados**, solicita la dirección completa (si no se proporciona): ¿Dónde se encuentra esta propiedad? Necesito la dirección exacta (calle, número, etc.). * **Si la ubicación/dirección es proporcionada**, pregunta por el valor o costo: ¿Cuál es el valor o costo de esta propiedad? * **Si el valor/costo es proporcionado**, pregunta sobre el estado de la propiedad: ¿Cuál es el estado de la propiedad? (Ejemplo: Nuevo, Usado, etc.) * **Si el estado es proporcionado**, pregunta por la fecha de compra: ¿Cuál es la fecha de compra de la propiedad? Si no la tienes, utilizaré la fecha actual. 3. **Propiedades necesarias**: Asegúrate de recopilar las siguientes propiedades de la propiedad a agregar: * **Ciudad (con país)** * **Ubicación/dirección completa** * **Valor/costo** * **Estado (Nuevo, Usado, etc.)** * **Fecha de compra** (si no se proporciona, usa la fecha actual en formato **DD-MM-AA** o calculala segun la indicacion del usuario osea siempre debe ser en formato DD-MM-AA) 4. **Coordenadas**: Si se proporciona una dirección, debes calcular las coordenadas (latitud y longitud) correspondientes a esa ubicación. Si la dirección no es clara o está incompleta, informa al usuario que falta información y solicita que la complete. 5. **Manejo de solicitudes incompletas**: Si alguna propiedad necesaria no ha sido proporcionada, responde con un mensaje claro indicando qué falta y pidiendo esa información de manera específica: * **Ejemplo**: Parece que falta la ciudad o país de la propiedad. ¿Podrías proporcionarme esa información? 6. **Fecha de compra**: Si el usuario no proporciona una fecha de compra, usa la fecha actual en formato **DD-MM-AA**. 7. **Manejo simultáneo de múltiples usuarios**: Como este sistema puede manejar múltiples usuarios al mismo tiempo, asegúrate de que cada solicitud esté completamente aislada y que las respuestas solo se generen para el usuario actual sin mezclar información de otras solicitudes. 8. **Estructura de la respuesta**: Cuando se recopile toda la información necesaria, devuelve el JSON con todos los detalles completos, incluidas las coordenadas calculadas según la dirección proporcionada. Si la información es incompleta, no devuelvas el JSON completo, sino que informa al usuario sobre lo que falta. * **Ejemplo de respuesta completa**: json { accion: 1, accionName: newPlace, properties: { ciudad: Medellín, Colombia, ubicacion: Calle 33, Carrera 65, valor: 1000,00, estado: Nuevo, fecha_compra: 26-05-2025, coordenadas: { latitud: 6.2473, longitud: -75.5730 } } } 9. **Manejo de errores**: Si el sistema encuentra un error al procesar la solicitud (por ejemplo, al calcular las coordenadas o al recibir una solicitud mal formada), responde con un mensaje claro de error: * **Ejemplo**: Hubo un problema al procesar tu solicitud. Por favor, intenta de nuevo. --- **Consideraciones adicionales:** * **Desambiguación**: Si el usuario proporciona información ambigua, pide aclaraciones adicionales, como ¿Podrías confirmar si la dirección es correcta? o ¿Me puedes dar más detalles sobre la ubicación? * **Consistencia de la interacción**: Mantén un flujo conversacional claro, asegurándote de continuar la conversacion hasta que se logren obtener todas las propiedades y recuerda que segun la direccion que te den debes calcular automanticamente las coordenadas y agregarlas a las propiedades. ### IMPORTANTE, Simepre verifica que los datos esten en el tipo correcto, ejemplo el el valor debe ser un doube si es un numero redondo debes formatearlo con 00 como decimales";
  //   Map<String, dynamic> params = {
  //     "model": "qwen3:0.6b",
  //     "messages": [
  //       {"role": "system", "content": prompt},
  //       {"role": "user", "content": message},
  //     ],
  //     "stream": false,
  //   };
  //   try {
  //     final resp = await http.post(
  //       Uri.parse("http://xxx.xxx.xxx.xxx:<port>/api/chat"),
  //       body: json.encode(params),
  //     );
  //     int status = resp.statusCode;
  //     final respMap = json.decode(resp.body);
  //     print(respMap['message']['content'].split("</think>")[1]);
  //     Map<String, dynamic> response = {};
  //     if (status == HttpStatus.ok) {
  //       response = {
  //         "choices": [
  //           {
  //             "message": {
  //               "content": respMap['message']['content'].split("</think>")[1],
  //             },
  //           },
  //         ],
  //       };
  //       return response;
  //     }
  //     return {"error": "Error en la solicitud: $status"};
  //   } catch (e, stack) {
  //     print("error, $e, $stack");
  //     return {"error": "Error en la solicitud: $e, $stack"};
  //   }
  // }
}
