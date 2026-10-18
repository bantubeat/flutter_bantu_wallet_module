import 'package:flutter/widgets.dart' show Locale;

/// Legal documents the wallet module may link to.
///
/// The module never hard-codes their addresses: the host application maps each
/// document to an URL through a [WalletLegalUrlBuilder].
enum WalletLegalDoc {
  /// Payment policy and conditions.
  payment,

  /// Terms of purchase and use of Beatzcoins.
  beatzcoins,

  /// General terms of use.
  terms,

  /// Privacy policy.
  privacy,

  /// Help center / legal home page.
  helpCenter,
}

/// Builds the URL of a legal [doc] for the given [locale].
typedef WalletLegalUrlBuilder = String Function(
  WalletLegalDoc doc,
  Locale locale,
);
