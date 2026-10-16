import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/generated/locale_keys.g.dart';
import '../../../../../layers/presentation/localization/string_translate_extension.dart';
import '../../../../../layers/presentation/pages/deposit/controller/deposit_controller.dart';
import '../../../helpers/ui_alert_helpers.dart';
import '../../../widgets/payments_icon_svg_image.dart';
import 'google_pay_live_button.dart';

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
          // icon: Icon(Icons.credit_card),
          //title: LocaleKeys.wallet_module_deposit_page_credit_or_visa_card.tr(),
          onTap: onCreditOrVisaCard,
          row: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Card',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
              ...PaymentsIcon.values.map(
                (icon) => PaymentsIconSvgImage(icon: icon),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        // Apple Pay and Google Pay options
        if (Platform.isAndroid)
          Builder(
            builder: (context) {
              final country = ctrl.currentUser?.pays.toUpperCase();
              final currency = ctrl.selectedCurrencyCode?.toUpperCase();
              final amount =
                  num.tryParse(ctrl.amountCtrl.text)?.toDouble() ?? 0.0;
              if (country == null || currency == null) {
                return const SizedBox.shrink();
              }

              // GooglePayLiveButton (et non GooglePayButton) : il s'abonne à
              // l'EventChannel `pay/payment_result` une seule fois et relit le
              // montant dans le controller au moment du paiement. Cela évite
              // que le plugin utilise le montant figé au moment où le bouton
              // est apparu (ex. "100" → "1") sans recréer le bouton (et donc
              // sans provoquer `illegalEventChannelState`).
              return GooglePayLiveButton(
                ctrl: ctrl,
                enabled: amount > 0,
                onDisabledTap: () {
                  UiAlertHelpers.showErrorSnackBar(
                    context,
                    LocaleKeys
                        .wallet_module_deposit_page_amount_and_currency_required
                        .tr(),
                  );
                },
              );
            },
          ),
        /*
        Row(
          children: [
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
            ),
          ],
        ), */
        const SizedBox(height: 16),
        // PayPal Option
        _buildButton(
          icon: const Icon(Icons.paypal, color: Colors.white),
          title: 'PayPal',
          onTap: onPayPal,
          textColor: Colors.white,
          backgroundColor: const Color(0xFF0070BA),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    Widget? icon,
    String? title,
    Color? backgroundColor,
    Color? textColor = Colors.black,
    Widget? row,
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
        child: row ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon,
                const SizedBox(width: 7),
                if (title != null)
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
