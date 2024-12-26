import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_modular/flutter_modular.dart';

import '../../../flutter_bantu_wallet_module.dart';

final class MyAppEnv {
  MyAppEnv._();

  static bool get isProduction =>
      Modular.tryGet<bool>(key: WalletModule.isProductionKey) ?? kReleaseMode;
}
