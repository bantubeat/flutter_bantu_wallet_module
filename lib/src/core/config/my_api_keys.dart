import 'package:flutter_bantu_wallet_module/src/core/config/wallet_api_keys.dart';
import 'package:flutter_modular/flutter_modular.dart';

final class MyApiKeys {
  const MyApiKeys._();

  static WalletApiKeys get _apiKey => Modular.get<WalletApiKeys>();

  static String get flutterwavePublicKey => _apiKey.getFlutterwavePublicKey();

  static String get paypalClientID => _apiKey.getPaypalClientID();

  static String get stripePublishableKey => _apiKey.getStripePublishableKey();
}
