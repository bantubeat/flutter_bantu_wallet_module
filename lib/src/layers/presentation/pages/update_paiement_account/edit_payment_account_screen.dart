import 'package:country_code_picker/country_code_picker.dart' show CountryCode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payout_method_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/balance/get_payout_methods_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/check_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/check_payment_preferences_email_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/get_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/resend_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/resend_payment_preferences_email_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/update_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/register_paiement_account/add_payment_account_screen.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/register_paiement_account/mobile_money_otp_verification_screen.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/register_paiement_account/widgets/whatsapp_warning_modal.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/otp_code_modal.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../helpers/image_picker_helper.dart';
import '../add_or_edit_payment_account/ui_model/ui_model.dart';

const _textPrimary = Color(0xFF1A1A2E);
const _textSecondary = Color(0xFF6B7280);
const _fieldFillDisabled = Color(0xFFECEDF1);
const _primaryButton = Color(0xFF0F1F4B);
const _border = Color(0xFFD9DBE3);

const _h1 = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w800,
  color: _textPrimary,
);
const _fieldLabel = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: _textPrimary,
);
const _fieldValue = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: _textPrimary,
);
const _fieldHint = TextStyle(
  fontSize: 15,
  color: Color(0xFF9CA3AF),
);
const _helperText = TextStyle(
  fontSize: 12,
  height: 1.4,
  color: _textSecondary,
);

const _monthKeys = [
  LocaleKeys.wallet_module_payment_account_months_january,
  LocaleKeys.wallet_module_payment_account_months_february,
  LocaleKeys.wallet_module_payment_account_months_march,
  LocaleKeys.wallet_module_payment_account_months_april,
  LocaleKeys.wallet_module_payment_account_months_may,
  LocaleKeys.wallet_module_payment_account_months_june,
  LocaleKeys.wallet_module_payment_account_months_july,
  LocaleKeys.wallet_module_payment_account_months_august,
  LocaleKeys.wallet_module_payment_account_months_september,
  LocaleKeys.wallet_module_payment_account_months_october,
  LocaleKeys.wallet_module_payment_account_months_november,
  LocaleKeys.wallet_module_payment_account_months_december,
];

String _monthName(int month) => _monthKeys[month - 1].tr();

String _flagEmoji(String iso) {
  final code = iso.toUpperCase();
  return String.fromCharCodes(
    code.codeUnits.map((u) => 0x1F1E6 + u - 0x41),
  );
}

class EditPaymentAccountScreen extends StatefulWidget {
  final PaymentPreferenceEntity currentPaymentPreference;

  const EditPaymentAccountScreen({
    required this.currentPaymentPreference,
    super.key,
  });

  @override
  State<EditPaymentAccountScreen> createState() =>
      _EditPaymentAccountScreenState();
}

class _EditPaymentAccountScreenState extends State<EditPaymentAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late EAccountType _type = widget.currentPaymentPreference.accountType;

  bool get _isMobileMoney => _type == EAccountType.mobile;

  CountryCode? _country;
  List<PayoutOperatorEntity> _operators = [];
  PayoutOperatorEntity? _selectedOperator;
  bool _loading = true;
  bool _submitting = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ibanController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _swiftController = TextEditingController();

  int? _dobDay;
  int? _dobMonth;
  int? _dobYear;

  XFile? _documentXFile;
  String? _documentName;

  @override
  void initState() {
    super.initState();
    _prefill();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _loadOperators(widget.currentPaymentPreference.detailOperator),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    _swiftController.dispose();
    super.dispose();
  }

  void _prefill() {
    _fillFromPreference(widget.currentPaymentPreference);
  }

  /// Remplit les champs depuis une préférence existante du type ciblé.
  /// Les champs spécifiques à l'autre type sont vidés.
  void _fillFromPreference(PaymentPreferenceEntity pref) {
    _country = CountryCode.tryFromCountryCode(
          (pref.detailCountry ?? '').toUpperCase(),
        ) ??
        CountryCode.fromCountryCode('CM');

    final fullName = _splitFullName(pref.detailName ?? '');
    _firstNameController.text = pref.firstName ?? fullName.firstName;
    _lastNameController.text = pref.lastName ?? fullName.lastName;

    _streetController.text = pref.street ?? '';
    _cityController.text = pref.city ?? '';
    _postalCodeController.text = pref.postalCode ?? '';

    final birthDate = pref.birthDate;
    if (birthDate != null) {
      _dobDay = birthDate.day;
      _dobMonth = birthDate.month;
      _dobYear = birthDate.year;
    } else {
      _dobDay = null;
      _dobMonth = null;
      _dobYear = null;
    }

    if (_isMobileMoney) {
      _phoneController.text =
          _stripDialCode(pref.detailPhone ?? '', _country?.dialCode);
      _ibanController.text = '';
      _swiftController.text = '';
      _bankNameController.text = '';
    } else {
      _ibanController.text = pref.detailIban ?? '';
      _swiftController.text = pref.detailBic ?? '';
      _bankNameController.text = pref.detailBankName ?? '';
      _phoneController.text = '';
      _selectedOperator = null;
    }
  }

  /// Vide uniquement les champs spécifiques au type de compte (numéro
  /// mobile/opérateur ou IBAN/BIC/banque) ; les infos communes (nom,
  /// prénom, adresse, date de naissance) sont conservées.
  void _clearTypeSpecificFields() {
    _phoneController.text = '';
    _ibanController.text = '';
    _swiftController.text = '';
    _bankNameController.text = '';
    _selectedOperator = null;
    _documentXFile = null;
    _documentName = null;
  }

  Future<void> _loadOperators([String? operatorName]) async {
    if (_isMobileMoney) {
      try {
        final payoutMethods =
            await Modular.get<GetPayoutMethodsUseCase>().call(NoParms());
        _operators = payoutMethods.mobileMoneyOperators;
        if (operatorName != null) {
          for (final op in _operators) {
            if (op.name.toLowerCase() == operatorName.toLowerCase()) {
              _selectedOperator = op;
              break;
            }
          }
        }
      } catch (err) {
        debugPrint('[EditPaymentAccountScreen] payout methods error: $err');
        _operators = [];
      }
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  ({String firstName, String lastName}) _splitFullName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return (firstName: '', lastName: '');
    }
    if (parts.length == 1) return (firstName: parts[0], lastName: '');
    return (firstName: parts.first, lastName: parts.sublist(1).join(' '));
  }

  String _stripDialCode(String phone, String? dialCode) {
    if (dialCode != null && phone.startsWith(dialCode)) {
      return phone.substring(dialCode.length);
    }
    return phone;
  }

  // ---------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------

  Future<void> _pickDocument() async {
    ImagePickerHelper.showPickImage(
      context,
      onImagePicked: (image) {
        if (image == null) return;
        setState(() {
          _documentXFile = image;
          _documentName = image.name;
        });
      },
    );
  }

  /// Permet de changer le type de compte (banque <-> mobile). Si un compte
  /// du nouveau type existe déjà, ses champs sont préremplis ; sinon seules
  /// les infos communes (nom, prénom, adresse, date de naissance) sont
  /// conservées.
  Future<void> _onChangeType() async {
    final chosen = await AddPaymentAccountScreen.show(context);
    if (chosen == null || !mounted || chosen == _type) return;

    if (chosen == EAccountType.mobile) {
      final res = await WhatsappWarningModal.show(context);
      if (!res || !mounted) return;
    }

    PaymentPreferenceEntity? existing;
    try {
      final preferences =
          await Modular.get<GetPaymentPreferencesUseCase>().call(NoParms());
      if (!mounted) return;
      for (final pref in preferences) {
        if (pref.accountType == chosen) {
          existing = pref;
          break;
        }
      }
    } catch (err) {
      debugPrint('[EditPaymentAccountScreen] payment preferences error: $err');
    }

    setState(() {
      _type = chosen;
      if (existing != null) {
        _fillFromPreference(existing);
      } else {
        _clearTypeSpecificFields();
      }
    });
    await _loadOperators(existing?.detailOperator);
  }

  String get _fullPhoneNumber =>
      '${(_country?.dialCode ?? '')}${_phoneController.text.trim()}';

  String? _requiredValidator(String? v, [int min = 1]) {
    final required =
        LocaleKeys.wallet_module_payment_account_update_required.tr();
    if (v == null || v.trim().isEmpty) return required;
    if (v.trim().length < min) {
      return LocaleKeys.wallet_module_payment_account_update_required_min.tr(
        namedArgs: {'min': '$min'},
      );
    }
    return null;
  }

  PaymentAccountFormDataType? _buildFormData() {
    if (_dobDay == null || _dobMonth == null || _dobYear == null) {
      return null;
    }
    final accountHolder = (
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      birthdate: DateTime(_dobYear!, _dobMonth!, _dobDay!),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
    );

    if (_isMobileMoney) {
      return PaymentAccountFormDataType.mobilePayment(
        paymentCountry: _country!,
        mobileOperator: _selectedOperator!.name,
        mobileAccountNumber: _fullPhoneNumber,
        otherDocument: _documentXFile,
        accountHolder: accountHolder,
      );
    }
    return PaymentAccountFormDataType.bankPayment(
      bankName: _bankNameController.text.trim(),
      bankAccountNumber: _ibanController.text.trim(),
      bankSwiftCode: _swiftController.text.trim(),
      bankDocument: _documentXFile,
      accountHolder: accountHolder,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isMobileMoney && _selectedOperator == null) {
      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_payment_account_update_select_operator.tr(),
      );
      return;
    }
    if (_isMobileMoney && _phoneController.text.isEmpty) {
      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_payment_account_update_enter_mobile_number
            .tr(),
      );
      return;
    }
    if (_dobDay == null || _dobMonth == null || _dobYear == null) {
      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_payment_account_update_enter_birthdate.tr(),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final formData = _buildFormData();
      final paymentPrefInput = formData?.toPaymentPreferenceInput();
      if (paymentPrefInput == null) return;

      final preference = await Modular.get<UpdatePaymentPreferencesUseCase>()
          .call(paymentPrefInput);
      final preferenceUuid = preference.uuid;

      if (_isMobileMoney) {
        if (!mounted) return;
        final verified = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => MobileMoneyOtpVerificationScreen(
              fullPhoneNumber: _fullPhoneNumber,
              onVerify: (code) =>
                  Modular.get<CheckPaymentPreferencesVerificationCodeUseCase>()
                      .call((uuid: preferenceUuid, code: code)),
              onResend: () =>
                  Modular.get<ResendPaymentPreferencesVerificationCodeUseCase>()
                      .call(NoParms()),
            ),
          ),
        );
        if (verified == true) {
          if (!mounted) return;
          await OtpCodeModal(
            title: LocaleKeys.wallet_module_payment_account_modal_title.tr(),
            description:
                LocaleKeys.wallet_module_payment_account_modal_description.tr(),
            handleSubmit: (context, code) async {
              final isValid = await Modular.get<
                      CheckPaymentPreferencesEmailVerificationCodeUseCase>()
                  .call((uuid: preferenceUuid, code: code));
              if (!isValid || !context.mounted) return;
              Navigator.pop(context);
              _returnToPreviousScreen();
            },
            handleResend: (context) {
              return Modular.get<
                      ResendPaymentPreferencesEmailVerificationCodeUseCase>()
                  .call((uuid: preferenceUuid));
            },
          ).show(context);
        }
      } else {
        if (!mounted) return;
        await OtpCodeModal(
          title: LocaleKeys.wallet_module_payment_account_modal_title.tr(),
          description:
              LocaleKeys.wallet_module_payment_account_modal_description.tr(),
          handleSubmit: (context, code) async {
            final isValid = await Modular.get<
                    CheckPaymentPreferencesVerificationCodeUseCase>()
                .call((uuid: preferenceUuid, code: code));
            if (!isValid || !context.mounted) return;
            Navigator.pop(context);
            _returnToPreviousScreen();
          },
          handleResend: (context) {
            return Modular.get<
                    ResendPaymentPreferencesVerificationCodeUseCase>()
                .call(NoParms());
          },
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _returnToPreviousScreen() {
    if (Modular.to.canPop()) {
      Modular.to.pop();
    } else {
      Modular.get<WalletRoutes>().home.navigate();
    }
  }

  // ---------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final title = _isMobileMoney
        ? LocaleKeys.wallet_module_payment_account_update_title_mobile.tr()
        : LocaleKeys.wallet_module_payment_account_update_title_bank.tr();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: _textPrimary),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    Text(title, style: _h1),
                    const SizedBox(height: 20),
                    _LabeledTextField(
                      label: LocaleKeys
                          .wallet_module_payment_account_update_account_holder_first_name
                          .tr(),
                      controller: _firstNameController,
                      helper: _isMobileMoney
                          ? LocaleKeys
                              .wallet_module_payment_account_update_account_holder_helper
                              .tr()
                          : LocaleKeys
                              .wallet_module_payment_account_update_account_holder_helper_bank
                              .tr(),
                      validator: _requiredValidator,
                    ),
                    _LabeledTextField(
                      label: LocaleKeys
                          .wallet_module_payment_account_update_account_holder_last_name
                          .tr(),
                      controller: _lastNameController,
                      helper: _isMobileMoney
                          ? LocaleKeys
                              .wallet_module_payment_account_update_account_holder_helper
                              .tr()
                          : LocaleKeys
                              .wallet_module_payment_account_update_account_holder_helper_bank
                              .tr(),
                      validator: _requiredValidator,
                    ),
                    _LockedField(
                      label: LocaleKeys.wallet_module_common_country.tr(),
                      child: Row(
                        children: [
                          Text(
                            _flagEmoji(_country?.code ?? ''),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(_country?.name ?? '', style: _fieldValue),
                        ],
                      ),
                    ),
                    _LabeledTextField(
                      label: LocaleKeys
                          .wallet_module_payment_account_update_address
                          .tr(),
                      controller: _streetController,
                      isLocked: true,
                      helper: LocaleKeys
                          .wallet_module_payment_account_update_address_helper
                          .tr(),
                      validator: _requiredValidator,
                    ),
                    _LabeledTextField(
                      label: LocaleKeys.wallet_module_common_city.tr(),
                      controller: _cityController,
                      isLocked: true,
                      helper: LocaleKeys
                          .wallet_module_payment_account_update_address_helper
                          .tr(),
                      validator: _requiredValidator,
                    ),
                    _LabeledTextField(
                      label: LocaleKeys.wallet_module_common_postal_code.tr(),
                      controller: _postalCodeController,
                      isLocked: true,
                      helper: LocaleKeys
                          .wallet_module_payment_account_update_address_helper
                          .tr(),
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LocaleKeys.wallet_module_common_birthdate.tr(),
                      style: _fieldLabel,
                    ),
                    const SizedBox(height: 8),
                    _DobRow(
                      day: _dobDay,
                      month: _dobMonth,
                      year: _dobYear,
                      onChanged: (d, m, y) {
                        setState(() {
                          _dobDay = d;
                          _dobMonth = m;
                          _dobYear = y;
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      LocaleKeys
                          .wallet_module_payment_account_update_birthdate_helper
                          .tr(),
                      style: _helperText,
                    ),
                    const SizedBox(height: 18),
                    _TypeField(
                      label: LocaleKeys
                          .wallet_module_payment_account_update_account_type
                          .tr(),
                      value: _isMobileMoney
                          ? LocaleKeys
                              .wallet_module_payment_account_update_mobile_money
                              .tr()
                          : LocaleKeys
                              .wallet_module_payment_account_update_bank_account
                              .tr(),
                      onTap: _onChangeType,
                    ),
                    if (_isMobileMoney) ..._mobileMoneyFields(),
                    if (!_isMobileMoney) ..._bankFields(),
                    const SizedBox(height: 8),
                    _UploadCard(
                      fileName: _documentName,
                      onPickFile: _pickDocument,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ActionButton(
                        text: LocaleKeys
                            .wallet_module_payment_account_update_send
                            .tr(),
                        isLoading: _submitting,
                        backgroundColor: Colors.black,
                        onPressed: _submit,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: _submitting
                            ? null
                            : () => Navigator.of(context).maybePop(),
                        child: Text(
                          LocaleKeys.wallet_module_payment_account_update_cancel
                              .tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _textSecondary,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _mobileMoneyFields() {
    return [
      const SizedBox(height: 4),
      Text(
        LocaleKeys.wallet_module_payment_account_update_mobile_number.tr(),
        style: _fieldLabel,
      ),
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _fieldFillDisabled,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(_country?.dialCode ?? '', style: _fieldValue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: _fieldValue,
              validator: (v) => _requiredValidator(v, 2),
              decoration: InputDecoration(
                hintText: LocaleKeys
                    .wallet_module_payment_account_update_phone_hint
                    .tr(),
                hintStyle: _fieldHint,
                filled: true,
                fillColor: _fieldFillDisabled,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: _primaryButton, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        LocaleKeys.wallet_module_payment_account_update_mobile_help.tr(),
        style: _helperText,
      ),
      const SizedBox(height: 18),
      Text(
        LocaleKeys.wallet_module_payment_account_mobile_operator_name.tr(),
        style: _fieldLabel,
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<PayoutOperatorEntity>(
        initialValue: _selectedOperator,
        isExpanded: true,
        decoration: InputDecoration(
          hintText: _operators.isEmpty
              ? LocaleKeys.wallet_module_payment_account_update_no_operator.tr()
              : LocaleKeys.wallet_module_payment_account_update_operator_hint
                  .tr(),
          hintStyle: _fieldHint,
          filled: true,
          fillColor: _fieldFillDisabled,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primaryButton, width: 1.5),
          ),
        ),
        items: _operators
            .map((op) => DropdownMenuItem(value: op, child: Text(op.name)))
            .toList(),
        onChanged: _operators.isEmpty
            ? null
            : (op) => setState(() => _selectedOperator = op),
        validator: (op) => op == null
            ? LocaleKeys.wallet_module_payment_account_update_operator_required
                .tr()
            : null,
      ),
      const SizedBox(height: 6),
      Text(
        LocaleKeys.wallet_module_payment_account_update_bank_helper.tr(),
        style: _helperText,
      ),
      const SizedBox(height: 18),
    ];
  }

  List<Widget> _bankFields() {
    final helper =
        LocaleKeys.wallet_module_payment_account_update_bank_helper.tr();
    return [
      _LabeledTextField(
        label: LocaleKeys.wallet_module_common_iban.tr(),
        controller: _ibanController,
        isLocked: true,
        helper: helper,
        validator: _requiredValidator,
      ),
      _LabeledTextField(
        label: LocaleKeys.wallet_module_payment_account_update_swift_bic.tr(),
        controller: _swiftController,
        isLocked: true,
        helper: helper,
      ),
      _LabeledTextField(
        label: LocaleKeys.wallet_module_common_bank_name.tr(),
        controller: _bankNameController,
        isLocked: true,
        helper: helper,
      ),
    ];
  }
}

class _LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? helper;
  final bool isLocked;
  final String? Function(String?)? validator;

  const _LabeledTextField({
    required this.label,
    required this.controller,
    this.helper,
    this.isLocked = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            style: _fieldValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: isLocked ? _fieldFillDisabled : Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isLocked
                    ? BorderSide.none
                    : const BorderSide(color: _border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isLocked
                    ? BorderSide.none
                    : const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _primaryButton, width: 1.5),
              ),
            ),
          ),
          if (helper != null) ...[
            const SizedBox(height: 6),
            Text(helper!, style: _helperText),
          ],
        ],
      ),
    );
  }
}

class _LockedField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LockedField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabel),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _fieldFillDisabled,
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Read-only "account type" field, styled to look like a dropdown (chevron
/// included) to match the design, even though the value is fixed by the
/// Champ "Type de compte de paiement" : le type est sélectionnable (le tap
/// ouvre le sélecteur de type de compte) car l'utilisateur peut passer d'un
/// type de compte à l'autre (banque <-> mobile).
class _TypeField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TypeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabel),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: _fieldValue),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of three dropdowns (jour / mois / année) used to edit the birth date,
/// matching the "14 ▼  Mai ▼  1986 ▼" layout from the mockups.
class _DobRow extends StatelessWidget {
  final int? day;
  final int? month;
  final int? year;
  final void Function(int? day, int? month, int? year) onChanged;

  const _DobRow({
    required this.day,
    required this.month,
    required this.year,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 1900 + 1, (i) => currentYear - i);

    return Row(
      children: [
        Expanded(
          child: _DobDropdown<int>(
            value: day,
            items: List.generate(31, (i) => i + 1),
            labelBuilder: (v) => '$v',
            onChanged: (v) => onChanged(v, month, year),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: _DobDropdown<int>(
            value: month,
            items: List.generate(12, (i) => i + 1),
            labelBuilder: (v) => _monthName(v),
            onChanged: (v) => onChanged(day, v, year),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DobDropdown<int>(
            value: year,
            items: years,
            labelBuilder: (v) => '$v',
            onChanged: (v) => onChanged(day, month, v),
          ),
        ),
      ],
    );
  }
}

class _DobDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const _DobDropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: _fieldFillDisabled,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryButton, width: 1.5),
        ),
      ),
      style: _fieldValue,
      items: items
          .map((v) => DropdownMenuItem(value: v, child: Text(labelBuilder(v))))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null
          ? LocaleKeys.wallet_module_payment_account_update_required.tr()
          : null,
    );
  }
}

/// Simple bordered upload card: greyed placeholder / current file name and a
/// pill-shaped "Upload +" / "Changer" button, matching the mockups.
class _UploadCard extends StatelessWidget {
  final String? fileName;
  final VoidCallback onPickFile;

  const _UploadCard({required this.onPickFile, this.fileName});

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Text(
            hasFile
                ? fileName!
                : LocaleKeys.wallet_module_payment_account_load_bank_docs.tr(),
            textAlign: TextAlign.center,
            style: hasFile ? _fieldValue : _fieldHint,
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: onPickFile,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: _fieldFillDisabled,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                hasFile
                    ? LocaleKeys.wallet_module_payment_account_update_change
                        .tr()
                    : LocaleKeys.wallet_module_payment_account_update_upload_cta
                        .tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: _textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
