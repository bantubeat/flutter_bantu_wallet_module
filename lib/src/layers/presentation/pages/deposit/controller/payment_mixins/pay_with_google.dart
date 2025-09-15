import 'dart:convert' show jsonDecode;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pay/pay.dart';

import '../../../../../../core/config/payment_configurations.dart';
import '../../../../../domain/use_cases/make_deposit_direct_payment_use_case.dart';
import '../../../../../domain/entities/enums/e_payment_method.dart';
import '../../../../../domain/entities/financial_transaction_entity.dart';
import '../../../../../presentation/helpers/ui_alert_helpers.dart';
import '../../../../../presentation/navigation/wallet_routes.dart';

mixin PayWithGoogle {
  PaymentConfiguration getGooglePaymentConfiguration({
    required String countryIso2,
    required String currency,
  }) {
    return PaymentConfiguration.fromJsonString(
      defaultGooglePay
          .replaceAll('"countryCode": "US"', '"countryCode": "$countryIso2"')
          .replaceAll('"currencyCode": "USD"', '"currencyCode": "$currency"'),
    );
  }

  Future<void> payWithGoogle({
    required double amount,
    required String countryIso2,
    required String currency,
  }) async {
    final payClient = Pay({
      PayProvider.google_pay: getGooglePaymentConfiguration(
        countryIso2: countryIso2,
        currency: currency,
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
    onGooglePayResult(result, amount: amount, currency: currency);
  }

  Future<void> onGooglePayResult(
    Map<String, dynamic>? result, {
    required double amount,
    required String currency,
  }) async {
    if (result == null) return;

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
        stripeToken: stripeToken,
        currency: currency,
        amount: amount,
      ),
    );

    if (tx.status == EFinancialTxStatus.success) {
      Modular.get<WalletRoutes>().transactions.navigate();
    }
  }
}
