import 'package:flutter/foundation.dart' show protected;

abstract class WalletApiKeys {
  @protected
  final bool isProduction;

  const WalletApiKeys({required this.isProduction});

  String getFlutterwavePublicKey();

  String getPaypalClientID();

  String getStripePublishableKey();
}
