import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'pdf_fonts.dart';

/// Génère un PDF à partir d'un titre et de couples libellé/valeur,
/// puis ouvre la boîte de dialogue d'impression.
Future<void> printDetailsPdf({
  required String title,
  required Map<String, String> details,
}) async {
  final document = pw.Document(
    theme: pw.ThemeData.withFont(
      base: await PdfFonts.regular(),
      bold: await PdfFonts.bold(),
    ),
  );
  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      build: (context) => <pw.Widget>[
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 16),
        for (final entry in details.entries) ...[
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    entry.key,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    entry.value,
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.Divider(color: PdfColors.grey300),
        ],
      ],
    ),
  );

  final bytes = await document.save();
  await Printing.layoutPdf(onLayout: (_) async => bytes);
}
