import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../widgets/action_button.dart';
import 'controller/deposit_controller.dart';
import 'widgets/e_u_payment_options.dart';
import 'widgets/payment_zone_switch.dart';

class DepositPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final summaryItemTextStyle = TextStyle(
      color: Color(0xFF5D5D5D),
      fontSize: 14,
    );
    final summaryTotalTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: colorScheme.onPrimary,
        appBar: AppBar(
          backgroundColor: colorScheme.onPrimary,
          title: FittedBox(
            child: Text(LocaleKeys.wallet_module_deposit_page_title.tr()),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScreenControllerBuilder(
            create: DepositController.new,
            builder: (context, ctrl) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Method Selection
                PaymentZoneSwitch(
                  isAfricanZone: ctrl.isAfricanZone,
                  onAfricanZoneTap: ctrl.switchZone,
                  onOtherZoneTap: ctrl.switchZone,
                ),
                // Currency Dropdown
                if (ctrl.isAfricanZone)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      LocaleKeys.wallet_module_deposit_page_choose_currency
                          .tr(),
                      style: TextStyle(fontSize: 18, color: Color(0xFF5D5D5D)),
                    ),
                  ),
                if (ctrl.isAfricanZone)
                  Skeletonizer(
                    enabled: ctrl.africanCurrencies.isEmpty ||
                        ctrl.currentUser == null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SelectFormField(
                        enableSearch: false,
                        type: SelectFormFieldType.dialog,
                        initialValue: ctrl.selectedCurrencyCode,
                        items: <Map<String, dynamic>>[
                          ...ctrl.africanCurrencies.map(
                            (curr) => {
                              'value': curr.code,
                              'label': '${curr.code} (${curr.description})',
                            },
                          ),
                        ],
                        onChanged: ctrl.selectCurrency,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Amount Input
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: TextField(
                    controller: ctrl.amountCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: LocaleKeys.wallet_module_deposit_page_amount.tr(
                        namedArgs: {'amount': ctrl.currency},
                      ),
                      fillColor: Color(0xFFD9D9D9), // D1D1D1
                      filled: true,
                      contentPadding: EdgeInsets.all(25),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Summary Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.wallet_module_deposit_page_price.tr(),
                        style: summaryItemTextStyle,
                      ),
                      Text(
                        ctrl.formattedAmount,
                        style: summaryItemTextStyle,
                      ),
                    ],
                  ),
                ),

                if (ctrl.isAfricanZone)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.wallet_module_deposit_page_fees.tr(
                            namedArgs: {
                              'percent':
                                  DepositController.feesPercent.toString(),
                            },
                          ),
                          style: summaryItemTextStyle,
                        ),
                        Text(
                          ctrl.formattedFees,
                          style: summaryItemTextStyle,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.wallet_module_deposit_page_total.tr(),
                        style: summaryTotalTextStyle,
                      ),
                      Text(
                        ctrl.formattedTotal,
                        style: summaryTotalTextStyle,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Continue Payment Button
                if (ctrl.isAfricanZone)
                  ActionButton(
                    onPressed: ctrl.onContinue,
                    text: LocaleKeys.wallet_module_deposit_page_continue_payment
                        .tr(),
                  ),

                if (!ctrl.isAfricanZone)
                  EUPaymentOptions(
                    onGooglePay: ctrl.onGooglePay,
                    onApplePay: ctrl.onApplePay,
                    onPayPal: ctrl.onPayPal,
                    onCreditOrVisaCard: ctrl.onCreditOrVisaCard,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
