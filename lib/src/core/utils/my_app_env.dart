import 'package:flutter/foundation.dart' show kReleaseMode;

final class MyAppEnv {
  MyAppEnv._();

  // ignore: dead_code
  static const isProduction = false && kReleaseMode;
}
