import 'dart:convert' show jsonDecode;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/e_payment_method.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/financial_transaction_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/navigation/wallet_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pay/pay.dart';

import '../../../../../../core/utils/payment_configurations.dart';
import '../../../../../domain/use_cases/make_deposit_direct_payment_use_case.dart';

mixin PayWithGoogle {
  Future<void> payWithGoogle({
    required double amount,
    required String countryIso2,
    required String currency,
  }) async {
    final payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(
        defaultGooglePay
            .replaceAll(
              '"countryCode": "US"',
              '"countryCode": "$countryIso2"',
            )
            .replaceAll(
              '"currencyCode": "USD"',
              '"currencyCode": "$currency"',
            ),
      ),
    });

    Map<String, dynamic>? result;
    try {
      result = await payClient.showPaymentSelector(
        PayProvider.google_pay,
        [
          PaymentItem(
            label: 'Total',
            amount: amount.toStringAsFixed(2),
            type: PaymentItemType.total,
            status: PaymentItemStatus.final_price,
          ),
        ],
      );
    } on PlatformException catch (e) {
      UiAlertHelpers.showErrorToast('${e.code}: ${e.message}');
      return;
    }

    debugPrint('result => $result');

    Map<String, dynamic>? paymentMethodData = result['paymentMethodData'];
    debugPrint('paymentMethodData => $paymentMethodData');
    if (paymentMethodData == null) return;

    Map<String, dynamic>? tokenizationData =
        paymentMethodData['tokenizationData'];
    debugPrint('tokenizationData => $tokenizationData');
    if (tokenizationData == null) return;

    final token = tokenizationData['token'];
    debugPrint('token => $token');
    if (token == null) return;

    late String stripeToken;

    try {
      final tokenMap = jsonDecode(token.toString());
      stripeToken = tokenMap['id'];
    } catch (_) {
      stripeToken = token;
    }

    debugPrint('stripeToken => $stripeToken');

    final tx = await Modular.get<MakeDepositDirectPaymentUseCase>().call(
      (
        paymentMethod: EPaymentMethod.stripe,
        amount: amount,
        currency: currency,
        stripeToken: stripeToken,
      ),
    );

    if (tx.status == EFinancialTxStatus.success) {
      Modular.get<WalletRoutes>().transactions.navigate();
    }
  }
}
