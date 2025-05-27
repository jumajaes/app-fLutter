import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ReadPdf extends StatelessWidget {
  final String path = 'assets/docs/ESCRITURA_PUBLICA_2060_0001.pdf';

  const ReadPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _preparePdf(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Error cargando PDF'));
        }

        return SizedBox(
          height: 400, 
          child: PDFView(
            filePath: snapshot.data!,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
          ),
        );
      },
    );
  }

  Future<String> _preparePdf(BuildContext context) async {
    final bytes = await DefaultAssetBundle.of(context).load(path);
    final dir = await Future.value(Directory.systemTemp);
    final file = File("${dir.path}/temp_pdf.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return file.path;
  }
}
