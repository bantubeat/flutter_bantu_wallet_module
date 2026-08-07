import '../config/my_app_env.dart';

final class ApiConstants {
  const ApiConstants._();

  static String get serverAddr => MyAppEnv.isProduction
      ? 'https://api-prod.bantubeat.com'
      : 'https://api.dev.bantubeat.com';
  static String get serverFeatAddr => MyAppEnv.isProduction
      ? 'https://api.feat-link.bantubeat.com'
      : 'https://api.feat-link.dev.bantubeat.com';

  static String get baseUrl => '$serverAddr/api';
  static String get saloondprivedBg =>
      'packages/flutter_bantu_wallet_module/assets/images/saloondprivedBg.png';
  static String get servicesProBg =>
      'packages/flutter_bantu_wallet_module/assets/images/servicesProBg.png';

  static String get websiteUrl => MyAppEnv.isProduction
      ? 'https://open.bantubeat.com'
      : 'https://test.dev.bantubeat.com';

  static const privacyPolicyUrl =
      'https://legal.bantubeat.com/bantubeat/privacy-policy';
}
