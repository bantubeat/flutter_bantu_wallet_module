import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import '../../../../../layers/presentation/pages/deposit/controller/deposit_controller.dart';
import '../../../../../layers/presentation/localization/string_translate_extension.dart';
import '../../../../../core/generated/locale_keys.g.dart';
import '../../../widgets/google_icon_svg_image.dart';

class EUPaymentOptions extends StatelessWidget {
  final VoidCallback onGooglePay;
  final VoidCallback onApplePay;
  final VoidCallback onPayPal;
  final VoidCallback onCreditOrVisaCard;
  final DepositController ctrl;

  const EUPaymentOptions({
    required this.ctrl,
    required this.onGooglePay,
    required this.onApplePay,
    required this.onPayPal,
    required this.onCreditOrVisaCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card Option
        _buildButton(
          icon: Icon(Icons.credit_card),
          title: LocaleKeys.wallet_module_deposit_page_credit_or_visa_card.tr(),
          onTap: onCreditOrVisaCard,
        ),
        SizedBox(height: 16),
        // Apple Pay and Google Pay options
        Row(
          children: [
            /*
            Expanded(
              child: _buildButton(
                icon: Icon(Icons.apple),
                title: 'Pay',
                onTap: onApplePay,
              ),
            ),
            SizedBox(width: 16),  */ /*
            Expanded(
              child: _buildButton(
                icon: GoogleIconSvgImage(),
                title: 'Pay',
                onTap: onGooglePay,
              ),
            ), */
            Expanded(
              child: Builder(
                builder: (context) {
                  final country = ctrl.currentUser?.pays.toUpperCase();
                  final currency = ctrl.selectedCurrencyCode?.toUpperCase();
                  final amount = num.tryParse(ctrl.amountCtrl.text)?.toDouble();
                  print(
                    'country == $country || currency == $currency || amount == $amount',
                  );
                  if (country == null || currency == null || amount == null) {
                    return SizedBox.shrink();
                  }
                  return GooglePayButton(
                    paymentConfiguration: ctrl.getGooglePaymentConfiguration(
                      countryIso2: country,
                      currency: currency,
                    ),
                    paymentItems: [
                      PaymentItem(
                        label: 'Total',
                        amount: amount.toStringAsFixed(2),
                        type: PaymentItemType.total,
                        status: PaymentItemStatus.final_price,
                      ),
                    ],
                    onPaymentResult: (result) {
                      print('Google Pay Result: $result');
                      ctrl.onGooglePayResult(
                        result,
                        amount: amount,
                        currency: currency,
                      );
                    },
                    buttonProvider: PayProvider.google_pay,
                    type: GooglePayButtonType.pay,
                    margin: const EdgeInsets.only(top: 15.0),
                    onError: (error) {
                      print('Google Pay Error: $error');
                    },
                    childOnError: const Center(child: Icon(Icons.warning)),
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    theme: Theme.of(context).colorScheme.brightness ==
                            Brightness.dark
                        ? GooglePayButtonTheme.dark
                        : GooglePayButtonTheme.light,
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        // PayPal Option
        _buildButton(
          icon: Icon(Icons.paypal, color: Colors.white),
          title: 'PayPal',
          onTap: onPayPal,
          textColor: Colors.white,
          backgroundColor: Color(0xFF0070BA),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildButton({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? textColor = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: backgroundColor ?? Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
