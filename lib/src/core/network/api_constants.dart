import '../config/my_app_env.dart';

final class ApiConstants {
  const ApiConstants._();

  static String get serverAddr => MyAppEnv.isProduction
      ? 'https://api-prod.bantubeat.com'
      : 'https://api.dev.bantubeat.com';

  static String get baseUrl => '$serverAddr/api';

  static String get websiteUrl => MyAppEnv.isProduction
      ? 'https://open.bantubeat.com'
      : 'https://test.dev.bantubeat.com';
}
