import 'package:country_code_picker/country_code_picker.dart' show CountryCode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/update_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../helpers/image_picker_helper.dart';
import 'ui_model/ui_model.dart';
import 'widgets/verification_code_modal.dart';

class AddPaymentAccountController extends ScreenController {
  EAccountType selectedAccountType = EAccountType.mobile;

  // Mobile account fields
  // Note: Mobile operator and account number are used for mobile accounts only
  CountryCode? selectedPaymentCountry;
  final mobileOperatorCtrl = TextEditingController(text: '');
  final mobileAccountNumberCtrl = TextEditingController(text: '');

  // Bank account fields
  // Note: Bank name, account number, and SWIFT code are not used for mobile
  final bankNameCtrl = TextEditingController(text: '');
  final bankAccountNumberCtrl = TextEditingController(text: '');
  final bankAccountNumberConfirmCtrl = TextEditingController(text: '');
  final bankSwiftCodeCtrl = TextEditingController(text: '');

  // Common for both mobile and bank accounts
  final accountHolderFirstNameCtrl = TextEditingController(text: '');
  final accountHolderLastNameCtrl = TextEditingController(text: '');
  final accountHolderStreetCtrl = TextEditingController(text: '');
  final accountHolderCityCtrl = TextEditingController(text: '');
  final accountHolderPostalCodeCtrl = TextEditingController(text: '');
  DateTime? _pickedBirthdate;

  XFile? _bankDocumentXFile;
  ImageProvider? bankDocument;

  AddPaymentAccountController(super.state);

  @protected
  @override
  void onDispose() {
    mobileOperatorCtrl.dispose();
    mobileAccountNumberCtrl.dispose();
    bankNameCtrl.dispose();
    bankAccountNumberCtrl.dispose();
    bankAccountNumberConfirmCtrl.dispose();
    bankSwiftCodeCtrl.dispose();

    accountHolderFirstNameCtrl.dispose();
    accountHolderLastNameCtrl.dispose();
    accountHolderStreetCtrl.dispose();
    accountHolderCityCtrl.dispose();
    accountHolderPostalCodeCtrl.dispose();
  }

  String get pickedBirthdate {
    final dt = _pickedBirthdate;
    if (dt == null) return '';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  void pickBirthdate() async {
    _pickedBirthdate = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    refreshUI();
  }

  void selectPaymentCountry(CountryCode countryCode) {
    selectedPaymentCountry = countryCode;
    refreshUI();
  }

  void setAccountType(EAccountType type) {
    selectedAccountType = type;
    refreshUI();
  }

  void pickBankDocument() {
    ImagePickerHelper.showPickImage(
      context,
      onImagePicked: (image) async {
        if (image != null) {
          _bankDocumentXFile = image;
          bankDocument = await image.toImageProvider();
          refreshUI();
        }
      },
    );
  }

  bool _requiredFieldsAreNotAllOk(Map<String, TextEditingController> reqCtrls) {
    if (_pickedBirthdate == null) {
      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_field_required.tr(
          namedArgs: {'field': LocaleKeys.wallet_module_common_birthdate.tr()},
        ),
      );
      return true;
    }

    final mustNotBeEmptyCtrls = {
      ...reqCtrls,
      LocaleKeys.wallet_module_common_first_name.tr():
          accountHolderFirstNameCtrl,
      LocaleKeys.wallet_module_common_last_name.tr(): accountHolderLastNameCtrl,
      LocaleKeys.wallet_module_common_city.tr(): accountHolderCityCtrl,
      LocaleKeys.wallet_module_common_street.tr(): accountHolderStreetCtrl,
    };
    for (final fieldName in mustNotBeEmptyCtrls.keys) {
      if (mustNotBeEmptyCtrls[fieldName]?.text.isEmpty ?? false) {
        UiAlertHelpers.showErrorSnackBar(
          context,
          LocaleKeys.wallet_module_common_field_required.tr(
            namedArgs: {'field': fieldName},
          ),
        );
        return true;
      }
    }

    return false;
  }

  PaymentAccountFormDataType? _validateMobileAccountInfos() {
    final country = selectedPaymentCountry;
    if (country == null) {
      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_field_required.tr(
          namedArgs: {'field': LocaleKeys.wallet_module_common_country.tr()},
        ),
      );
      return null;
    }

    if (_requiredFieldsAreNotAllOk({
      LocaleKeys.wallet_module_payment_account_mobile_operator_name.tr():
          mobileOperatorCtrl,
      LocaleKeys.wallet_module_payment_account_account_number.tr():
          mobileAccountNumberCtrl,
    })) {
      return null;
    }

    return PaymentAccountFormDataType.mobilePayment(
      paymentCountry: country,
      mobileOperator: mobileOperatorCtrl.text,
      mobileAccountNumber: mobileAccountNumberCtrl.text,
      otherDocument: _bankDocumentXFile,
      accountHolder: (
        firstName: accountHolderFirstNameCtrl.text,
        lastName: accountHolderLastNameCtrl.text,
        birthdate: _pickedBirthdate!,
        street: accountHolderStreetCtrl.text,
        city: accountHolderCityCtrl.text,
        postalCode: accountHolderPostalCodeCtrl.text,
      ),
    );
  }

  PaymentAccountFormDataType? _validateBankAccountInfos() {
    if (_requiredFieldsAreNotAllOk({
      LocaleKeys.wallet_module_payment_account_bank_name.tr(): bankNameCtrl,
      LocaleKeys.wallet_module_payment_account_account_number.tr():
          bankAccountNumberCtrl,
      LocaleKeys.wallet_module_payment_account_swift_code.tr():
          bankSwiftCodeCtrl,
    })) {
      return null;
    }

    if (bankAccountNumberCtrl.text != bankAccountNumberConfirmCtrl.text) {
      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_payment_account_bad_account_number_confirmation
            .tr(),
      );
      return null;
    }

    return PaymentAccountFormDataType.bankPayment(
      bankName: bankNameCtrl.text,
      bankAccountNumber: bankAccountNumberCtrl.text,
      bankSwiftCode: bankSwiftCodeCtrl.text,
      bankDocument: _bankDocumentXFile,
      accountHolder: (
        firstName: accountHolderFirstNameCtrl.text,
        lastName: accountHolderLastNameCtrl.text,
        birthdate: _pickedBirthdate!,
        street: accountHolderStreetCtrl.text,
        city: accountHolderCityCtrl.text,
        postalCode: accountHolderPostalCodeCtrl.text,
      ),
    );
  }

  void onNext() async {
    // Validate based on the selected account type
    final paymentAccountFormData = selectedAccountType == EAccountType.mobile
        ? _validateMobileAccountInfos()
        : _validateBankAccountInfos();

    final paymentPrefInput = paymentAccountFormData?.toPaymentPreferenceInput();

    // If paymentAccountFormData is null, it means validation failed
    if (paymentPrefInput == null) return;

    await Modular.get<UpdatePaymentPreferencesUseCase>().call(paymentPrefInput);

    if (context.mounted) VerificationCodeModal.show(context);
  }
}
