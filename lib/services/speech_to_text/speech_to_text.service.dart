import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kbox/layouts/main.layout.dart';
import 'package:kbox/services/http/http.service.dart';
import 'package:kbox/src/user_data/user_data.dart';
import 'package:kbox/util/loadings/page_loading.widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService extends StatefulWidget {
  const SpeechToTextService({super.key});

  @override
  State<SpeechToTextService> createState() => _SpeechToTextServiceState();
}

class _SpeechToTextServiceState extends State<SpeechToTextService> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<String> _text = [];
  String _textStr = "";

  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize();
    setState(() {
      _isInitialized = available;
      _isLoading = false;
    });
    print("Speech-to-Text initialized: $_isInitialized");
    if (!_isInitialized) _goToPorpertiesPage();
  }

  void _startListening() async {
    if (_isInitialized) {
      _textStr = "";
      Timer? silenceTimer;
      _speech.listen(
        onResult: (result) {
          silenceTimer?.cancel();
          print("Resultado: ${result.recognizedWords}");
          setState(() {
            _textStr = result.recognizedWords;
            //_isLoading = true;
          });

          silenceTimer = Timer(Duration(milliseconds: 1500), () {
            _stopListening();
            _textStr.isEmpty ? _text.add("hola") : _text.add(_textStr);
            String message = _text.join("/#%#/");
            _sendAsk(message);
          });
        },
      );
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  _goToPorpertiesPage() {
    Navigator.of(context).popAndPushNamed("/home");
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  void _sendAsk(String message) async {
    Map<String, dynamic> response = await HttpService().sendAskToChatGpt(
      message,
    );
    //Map<String, dynamic> response = await HttpService().sendAskToChat(message);
    if (response.containsKey("error")) {
      _goToPorpertiesPage();
    } else {
      if (response["choices"][0]["message"]["content"].contains("(stop)&")) {
        print("termino de crear el json");
        Map<String, dynamic>? json = extraerYDecodificarJson(
          response["choices"][0]["message"]["content"],
        );

        if (json != null) {
          print("JSON extraído: $json");
          Properties.instance.addProperty(Property.fromJson(json));
          setState(() {
            _text.add("todo ok se guardo correctamente la nueva propiedad.");
            _isLoading = false;
          });
          return;
        } else {
          print("No se pudo extraer un JSON válido.");
          _text.add(
            "Dame de nuevo el json, ya que, al parecer hay un error en la estructura.",
          );
          response = await HttpService().sendAskToChatGpt(_text.join("/#%#/"));
          //response = await HttpService().sendAskToChat(_text.join("/#%#/"));
          Map<String, dynamic>? json = extraerYDecodificarJson(
            response["choices"][0]["message"]["content"],
          );
          if (json != null) {
            print("JSON extraído: $json");
            Properties.instance.addProperty(Property.fromJson(json));
            setState(() {
              _text.add("todo ok se guardo correctamente la nueva propiedad.");
              _isLoading = false;
            });
            return;
          } else {
            setState(() {
              _text = ["Intentemos nuevamente, hubo un error."];
              _isLoading = false;
            });
            return;
          }
        }
      }
      setState(() {
        _text.add(response["choices"][0]["message"]["content"]);
        _isLoading = false;
      });
    }
  }

  dynamic extraerYDecodificarJson(String texto) {
    print(texto);
    try {
      int startIndex = texto.indexOf('{');
      int endIndex = texto.lastIndexOf('}');

      if (startIndex != -1 && endIndex != -1) {
        String jsonString = texto.substring(startIndex, endIndex + 1).trim();

        if (jsonString.startsWith('{') && jsonString.endsWith('}')) {
          return jsonDecode(jsonString);
        }
      }
    } catch (e) {
      print("Error al procesar el JSON: $e");
      return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child:
          _isLoading
              ? const PageLoadingWidget()
              : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.blueGrey[100],
                          width: double.infinity,
                          child:
                              _text.isEmpty
                                  ? Text(
                                    'Hablemos!',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                  : Text(
                                    _text[_text.length - 1],
                                    style: TextStyle(
                                      fontSize:
                                          _text[_text.length - 1].length < 300
                                              ? 20
                                              : _text[_text.length - 1].length <
                                                  400
                                              ? 15
                                              : _text[_text.length - 1].length >
                                                  650
                                              ? 9
                                              : 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_isListening) {
                              _stopListening();
                            } else {
                              _startListening();
                            }
                          },
                          child: Text(
                            _isListening
                                ? 'Detener Escucha'
                                : 'Iniciar Escucha',
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    if (!_isInitialized)
                      Text(
                        'Speech-to-Text no está disponible en este dispositivo.',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
    );
  }
}
