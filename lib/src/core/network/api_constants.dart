import '../utils/my_app_env.dart';

final class ApiConstants {
  const ApiConstants._();

  static const serverAddr = MyAppEnv.isProduction
      ? 'https://api-prod.bantubeat.com'
      : 'https://api.dev.bantubeat.com';

  static const baseUrl = '$serverAddr/api';

  static const websiteUrl = MyAppEnv.isProduction
      ? 'https://open.bantubeat.com'
      : 'https://test.dev.bantubeat.com';
}
