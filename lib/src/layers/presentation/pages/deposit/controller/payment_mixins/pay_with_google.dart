import 'package:pay/pay.dart';

import '../../../../../../core/utils/payment_configurations.dart';

mixin PayWithGoogle {
  void payWithGoogle({
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
              '""currencyCode": "$currency"',
            ),
      ),
    });

    final result = await payClient.showPaymentSelector(
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

    print(result);

    final stripeToken = result['tokenizationData']['token'];

    // TODO: Backend API call
  }
}
