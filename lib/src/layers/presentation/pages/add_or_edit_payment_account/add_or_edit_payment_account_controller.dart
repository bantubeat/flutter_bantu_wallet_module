part of 'add_or_edit_payment_account_page.dart';

class _AddOrEditPaymentAccountController extends ScreenController {
  PaymentPreferenceEntity? currentPaymentPreference;
  late EAccountType selectedAccountType;

  // Mobile account fields
  // Note: Mobile operator and account number are used for mobile accounts only
  CountryCode? selectedPaymentCountry;
  late final TextEditingController mobileOperatorCtrl;
  late final TextEditingController mobileAccountNumberCtrl;

  // Bank account fields
  // Note: Bank name, account number, and SWIFT code are not used for mobile
  late final TextEditingController bankNameCtrl;
  late final TextEditingController bankAccountNumberCtrl;
  late final TextEditingController bankAccountNumberConfirmCtrl;
  late final TextEditingController bankSwiftCodeCtrl;

  // Common for both mobile and bank accounts
  late final TextEditingController accountHolderFirstNameCtrl;
  late final TextEditingController accountHolderLastNameCtrl;
  late final TextEditingController accountHolderStreetCtrl;
  late final TextEditingController accountHolderCityCtrl;
  late final TextEditingController accountHolderPostalCodeCtrl;
  DateTime? _pickedBirthdate;

  XFile? _bankDocumentXFile;
  ImageProvider? bankDocument;

  _AddOrEditPaymentAccountController(
    super.state,
    this.currentPaymentPreference,
  );

  @override
  @protected
  void onInit() {
    final pref = currentPaymentPreference;

    selectedAccountType = pref?.accountType ?? EAccountType.mobile;

    // Mobile account fields
    selectedPaymentCountry = CountryCode.tryFromCountryCode(
      pref?.detailCountry ?? '',
    );
    mobileOperatorCtrl = TextEditingController(
      text: pref?.detailOperator ?? '',
    );
    mobileAccountNumberCtrl = TextEditingController(
      text: pref?.detailPhone ?? '',
    );

    // Bank account fields
    bankNameCtrl = TextEditingController(text: pref?.detailBankName ?? '');
    bankAccountNumberCtrl = TextEditingController(text: pref?.detailIban ?? '');
    bankSwiftCodeCtrl = TextEditingController(text: pref?.detailBic ?? '');
    bankAccountNumberConfirmCtrl = TextEditingController(text: '');

    // Common for both mobile and bank accounts
    final names = _splitFullName(pref?.detailName ?? '');
    accountHolderFirstNameCtrl = TextEditingController(text: names.firstName);
    accountHolderLastNameCtrl = TextEditingController(text: names.lastName);
    accountHolderStreetCtrl = TextEditingController(text: '');
    accountHolderCityCtrl = TextEditingController(text: '');
    accountHolderPostalCodeCtrl = TextEditingController(text: '');
  }

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

  ({String firstName, String lastName}) _splitFullName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return (firstName: parts[0], lastName: '');
    }
    final firstName = parts.first;
    final lastName = parts.sublist(1).join(' ');
    return (firstName: firstName, lastName: lastName);
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

    if (!context.mounted) return;
    OtpCodeModal(
      title: LocaleKeys.wallet_module_payment_account_modal_title.tr(),
      description:
          LocaleKeys.wallet_module_payment_account_modal_description.tr(),
      handleSubmit: (context, code) async {
        final isValid =
            await Modular.get<CheckPaymentPreferencesVerificationCodeUseCase>()
                .call(code);
        if (!isValid || !context.mounted) return;
        Navigator.pop(context);
        Modular.get<WalletRoutes>().withdrawal.navigate();
      },
      handleResend: (context) {
        return Modular.get<ResendPaymentPreferencesVerificationCodeUseCase>()
            .call(NoParms());
      },
    ).show(context);
  }
}
