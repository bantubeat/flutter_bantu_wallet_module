import 'package:flutter/material.dart';

import 'i18n/fr.dart' as fr;
import 'i18n/en.dart' as en;
import 'my_localization.dart';

/// The MyLocalization delegate class.
class MyLocalizationDelegate extends LocalizationsDelegate<MyLocalization> {
  /// Contains all supported locales.
  final List<Locale> supportedLocales;

  /// The get path function.
  final GetLangMapFunction getLangMapFunction;

  /// The string to return if the key is not found.
  final String notFoundString;

  /// The locale to force (if specified, not recommended except under special circumstances).
  final Locale? locale;

  /// Creates a new app localization delegate instance.
  const MyLocalizationDelegate({
    required this.supportedLocales,
    this.getLangMapFunction = MyLocalizationDelegate.defaultGetLangMapFunction,
    this.notFoundString = MyLocalization.defaultNotFoundString,
    this.locale,
  });

  @override
  bool isSupported(Locale locale) =>
      _isLocaleSupported(supportedLocales, locale) != null;

  @override
  Future<MyLocalization> load(Locale locale) async {
    final localization = MyLocalization(
      locale: this.locale ?? locale,
      getLangMapFunction: getLangMapFunction,
      notFoundString: notFoundString,
    );

    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(MyLocalizationDelegate old) => old.locale != locale;

  /// The default locale resolution callback.
  Locale localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (this.locale != null) {
      return this.locale!;
    }

    if (locale == null) {
      return supportedLocales.first;
    }

    return _isLocaleSupported(supportedLocales, locale) ??
        supportedLocales.first;
  }

  /// Returns the locale if it's supported by this localization delegate, null otherwise.
  Locale? _isLocaleSupported(Iterable<Locale> supportedLocales, Locale locale) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode ||
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }

    return null;
  }

  /// The default get path function.
  static Map<String, dynamic> defaultGetLangMapFunction(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return en.langMap;
      case 'fr':
      default:
        return fr.langMap;
    }
  }
}
