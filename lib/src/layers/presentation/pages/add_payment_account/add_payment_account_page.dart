import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';

import 'ui_model/ui_model.dart';
import 'add_payment_account_controller.dart';
import 'widgets/account_type_selector.dart';
import 'widgets/country_select_field.dart';
import 'widgets/payment_account_text_field.dart';
import 'widgets/upload_box.dart';

class AddPaymentAccountPage extends StatelessWidget {
  const AddPaymentAccountPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          iconSize: 40,
          onPressed: Modular.to.pop,
          icon: const Icon(Icons.chevron_left),
        ),
        title: Text(
          LocaleKeys.wallet_module_payment_account_title.tr().toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: kElevationToShadow[2],
              ),
              child: ScreenControllerBuilder(
                create: AddPaymentAccountController.new,
                builder: (context, controller) {
                  final isMobile =
                      controller.selectedAccountType == EAccountType.mobile;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.wallet_module_payment_account_title.tr(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            LocaleKeys.wallet_module_payment_account_description
                                .tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        LocaleKeys.wallet_module_payment_account_account_type
                            .tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      AccountTypeSelector(
                        selectedAccountType: controller.selectedAccountType,
                        onSelectAccountType: controller.setAccountType,
                      ),
                      const SizedBox(height: 16),
                      if (isMobile) ...[
                        CountrySelectField(
                          initialSelection:
                              controller.selectedPaymentCountry?.code,
                          onChanged: controller.selectPaymentCountry,
                        ),
                        const SizedBox(height: 16),
                        PaymentAccountTextField(
                          label: LocaleKeys
                              .wallet_module_payment_account_mobile_operator_name
                              .tr(),
                          controller: controller.mobileOperatorCtrl,
                        ),
                        const SizedBox(height: 16),
                        PaymentAccountTextField(
                          label: LocaleKeys
                              .wallet_module_payment_account_account_number
                              .tr(),
                          controller: controller.mobileAccountNumberCtrl,
                        ),
                      ] else ...[
                        PaymentAccountTextField(
                          label: LocaleKeys
                              .wallet_module_payment_account_account_number
                              .tr(),
                          controller: controller.bankAccountNumberCtrl,
                        ),
                        const SizedBox(height: 16),
                        PaymentAccountTextField(
                          label: LocaleKeys
                              .wallet_module_payment_account_confirm_account_number
                              .tr(),
                          controller: controller.bankAccountNumberConfirmCtrl,
                        ),
                        const SizedBox(height: 16),
                        PaymentAccountTextField(
                          label: LocaleKeys
                              .wallet_module_payment_account_bank_name
                              .tr(),
                          controller: controller.bankNameCtrl,
                        ),
                        const SizedBox(height: 16),
                        PaymentAccountTextField(
                          label: LocaleKeys
                              .wallet_module_payment_account_swift_code
                              .tr(),
                          controller: controller.bankSwiftCodeCtrl,
                        ),
                      ],
                      const SizedBox(height: 16),
                      PaymentAccountTextField(
                        label: LocaleKeys.wallet_module_common_first_name.tr(),
                        controller: controller.accountHolderFirstNameCtrl,
                      ),
                      const SizedBox(height: 16),
                      PaymentAccountTextField(
                        label: LocaleKeys.wallet_module_common_last_name.tr(),
                        controller: controller.accountHolderLastNameCtrl,
                      ),
                      const SizedBox(height: 16),
                      PaymentAccountTextField(
                        label: LocaleKeys.wallet_module_common_birthdate.tr(),
                        readOnly: true,
                        onTap: controller.pickBirthdate,
                        controller: TextEditingController(
                          text: controller.pickedBirthdate,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PaymentAccountTextField(
                        label: LocaleKeys.wallet_module_common_street.tr(),
                        controller: controller.accountHolderStreetCtrl,
                      ),
                      const SizedBox(height: 16),
                      PaymentAccountTextField(
                        label: LocaleKeys.wallet_module_common_city.tr(),
                        controller: controller.accountHolderCityCtrl,
                      ),
                      const SizedBox(height: 16),
                      PaymentAccountTextField(
                        label: LocaleKeys.wallet_module_common_postal_code.tr(),
                        controller: controller.accountHolderPostalCodeCtrl,
                      ),
                      const SizedBox(height: 24),
                      UploadBox(
                        image: controller.bankDocument,
                        onTap: controller.pickBankDocument,
                        label: LocaleKeys
                            .wallet_module_payment_account_load_bank_docs
                            .tr(),
                      ),
                      const SizedBox(height: 32),
                      ActionButton(
                        text: LocaleKeys.wallet_module_common_save.tr(),
                        onPressed: controller.onNext,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
