import '../../../flutter_bantu_wallet_module.dart';

final class MyAppEnv {
  MyAppEnv._();

  static bool get isProduction => WalletModule.getIsProduction();
}
