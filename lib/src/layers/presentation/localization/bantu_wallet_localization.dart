import 'package:flutter_translate/flutter_translate.dart';

class BantuWalletLocalization {
  static LocalizationDelegate? _delegate;

  const BantuWalletLocalization();

  // Localization configuration method
  static Future<void> ensureInitialized() async {
    if (_delegate != null) return;
    const supportedLocales = ['fr' /*, 'en' */];
    _delegate = await LocalizationDelegate.create(
      // kIsWeb ? 'i18n' : 'assets/i18n',lib/assets/i18n/
      // basePath: 'packages/flutter_bantu_wallet_module/assets/i18n',
      basePath: 'assets/packages/flutter_bantu_wallet_module/assets/i18n',
      fallbackLocale: supportedLocales.first,
      supportedLocales: supportedLocales,
      // preferences: ITranslatePreferences
    );
  }

  // Utility method for translations
  static String tr(
    String key, {
    Map<String, String>? namedArgs,
  }) {
    return translate(key, args: namedArgs);
  }

  static String plural(
    String key,
    num value, {
    Map<String, String>? namedArgs,
  }) =>
      translatePlural(key, value, args: namedArgs);

  // Get localization delegate for package
  static LocalizationDelegate get delegate {
    if (null == _delegate) {
      throw Exception(
        'Call BantuWalletLocalization.initialize before use in MaterialApp please',
      );
    }
    return _delegate!;
  }
}

/*
class BantuWalletSyncWithEasyLocalization extends ITranslatePreferences {
  final BuildContext context;

  BantuWalletSyncWithEasyLocalization(this.context);

  @override
  Future<Locale?> getPreferredLocale() async {
    return EasyLocalization.of(context)?.currentLocale;
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    await EasyLocalization.of(context)?.setLocale(locale);
  }
}
*/