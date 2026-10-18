import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/wallet_legal_doc.dart';
import '../wallet_module.dart';

/// Opens the legal documents provided by the host application.
///
/// When the host did not provide a [WalletLegalUrlBuilder], no legal link is
/// displayed.
final class LegalLinks {
  const LegalLinks._();

  static bool get isAvailable => WalletModule.getLegalUrlBuilder() != null;

  static Future<void> open(BuildContext context, WalletLegalDoc doc) async {
    final builder = WalletModule.getLegalUrlBuilder();
    if (builder == null) return;
    final uri = Uri.tryParse(builder(doc, Localizations.localeOf(context)));
    if (uri == null) return;

    try {
      if (await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) return;
    } catch (err) {
      debugPrint('[LegalLinks] in-app browser failed: $err');
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// A tappable [TextSpan] opening [doc]. Only display it when [isAvailable].
  static TextSpan span(
    BuildContext context,
    WalletLegalDoc doc, {
    required String text,
    TextStyle? style,
  }) {
    return TextSpan(
      text: text,
      style: style,
      recognizer: TapGestureRecognizer()..onTap = () => open(context, doc),
    );
  }
}
