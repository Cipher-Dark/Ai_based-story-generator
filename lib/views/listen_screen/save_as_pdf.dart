import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class SaveAsPdf {
  static late String path;
  static Future<void> saveTextAsPdf(String content) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              content,
              style: pw.TextStyle(font: ttf, fontSize: 20),
              textAlign: pw.TextAlign.justify,
            ),
          );
        },
      ),
    );

    // Save the PDF file
    final output = await getExternalStorageDirectory(); // For Android
    final file = File("${output!.path}/generated.pdf");
    await file.writeAsBytes(await pdf.save());
    path = file.path;
  }

  static void openPdf() {
    OpenFile.open(path);
  }
}

class PdfGenerator {
  static Future<void> generatePDF(String content) async {}
}
