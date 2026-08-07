import 'package:flutter/material.dart';

import 'my_localization.dart';
import 'my_localization_delegate.dart';

class BantuWalletLocalization {
  static MyLocalization? _localization;

  const BantuWalletLocalization();

  static MyLocalizationDelegate getDelegate(
    Locale currentLocale,
    List<Locale> locales,
  ) {
    return MyLocalizationDelegate(
      // The first language is your default language.
      supportedLocales: locales,
      locale: currentLocale,
    );
  }

  // Initializes the Overlay with context
  static Widget init(BuildContext context, Widget? child) {
    _localization = MyLocalization.of(context);
    return child!;
  }

  /// The language code of the current locale (e.g. 'fr', 'en').
  static String get currentLanguageCode =>
      _localization?.locale.languageCode ?? 'en';

  // Utility method for translations
  static String tr(
    String key, {
    Map<String, String>? namedArgs,
  }) {
    final value = _localization?.get(key, namedArgs);
    return value != null && value != _localization?.notFoundString
        ? value
        : key;
  }

  static String plural(
    String key,
    num value, {
    Map<String, String>? namedArgs,
  }) =>
      tr(key, namedArgs: namedArgs);
}
