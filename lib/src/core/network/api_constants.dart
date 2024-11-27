import 'package:flutter/foundation.dart' show kReleaseMode;

class ApiConstants {
  // ignore: dead_code
  static const _useProductionMode = false && kReleaseMode;

  static const serverAddr = _useProductionMode
      ? 'https://api-prod.bantubeat.com'
      : 'https://api.dev.bantubeat.com';

  static const baseUrl = '$serverAddr/api';
}
