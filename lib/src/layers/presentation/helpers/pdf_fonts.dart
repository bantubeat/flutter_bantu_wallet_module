import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Charge les polices Roboto embarquées pour la génération PDF.
///
/// Les polices intégrées (Helvetica) du package `pdf` ne couvrent pas
/// l'Unicode (symbole euro, etc.). On utilise donc Roboto (assets locaux).
class PdfFonts {
  PdfFonts._();

  static pw.Font? _regular;
  static pw.Font? _bold;

  static Future<pw.Font> regular() async =>
      _regular ??= pw.Font.ttf(await _load('Roboto-Regular.ttf'));

  static Future<pw.Font> bold() async =>
      _bold ??= pw.Font.ttf(await _load('Roboto-Bold.ttf'));

  static Future<ByteData> _load(String name) => rootBundle.load(
        'packages/flutter_bantu_wallet_module/assets/fonts/$name',
      );
}
