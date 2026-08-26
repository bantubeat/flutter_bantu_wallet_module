import 'package:country_code_picker/country_code_picker.dart' show CountryCode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payout_method_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_current_user_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/balance/get_payout_methods_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/check_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/check_payment_preferences_email_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/resend_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/resend_payment_preferences_email_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/update_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/otp_code_modal.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../helpers/image_picker_helper.dart';
import '../add_or_edit_payment_account/ui_model/ui_model.dart';
import 'add_payment_account_screen.dart';
import 'mobile_money_otp_verification_screen.dart';
import 'widgets/whatsapp_warning_modal.dart';

const _bg = Color(0xFFF8F8FC);
const _textPrimary = Color(0xFF1A1A2E);
const _textSecondary = Color(0xFF6B7280);
const _divider = Color(0xFFE5E7EB);
const _fieldFill = Color(0xFFF2F3F7);
const _fieldFillDisabled = Color(0xFFECEDF1);
const _primaryButton = Color(0xFF0F1F4B);

const _h1 = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w800,
  color: _textPrimary,
);
const _body = TextStyle(
  fontSize: 14,
  height: 1.5,
  color: _textSecondary,
);
const _appBarTitle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w800,
  letterSpacing: 1.2,
  color: _textPrimary,
);
const _fieldLabel = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.1,
  color: _textSecondary,
);
const _fieldValue = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: _textPrimary,
);
const _fieldHint = TextStyle(
  fontSize: 15,
  color: Color(0xFF9CA3AF),
);
const _uploadHint = TextStyle(
  fontSize: 12.5,
  height: 1.4,
  color: _textSecondary,
);

String _flagEmoji(String iso) {
  final code = iso.toUpperCase();
  return String.fromCharCodes(
    code.codeUnits.map((u) => 0x1F1E6 + u - 0x41),
  );
}

class PaymentAccountFormScreen extends StatefulWidget {
  final EAccountType? type;
  final PaymentPreferenceEntity? currentPaymentPreference;

  const PaymentAccountFormScreen({
    this.type,
    this.currentPaymentPreference,
    super.key,
  });

  @override
  State<PaymentAccountFormScreen> createState() =>
      _PaymentAccountFormScreenState();
}

class _PaymentAccountFormScreenState extends State<PaymentAccountFormScreen> {
  final _formKey = GlobalKey<FormState>();

  CountryCode? _country;
  List<PayoutOperatorEntity> _operators = [];
  PayoutOperatorEntity? _selectedOperator;
  bool _loadingCountry = true;

  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _ibanController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _swiftController = TextEditingController();

  DateTime? _dob;
  XFile? _documentXFile;
  String? _documentName;
  bool _submitting = false;

  EAccountType? _type;

  bool get _isMobileMoney => _type == EAccountType.mobile;

  /// Oblige l'utilisateur à valider l'avertissement WhatsApp avant de
  /// continuer avec un compte Mobile Money. Le modal n'est pas dismissible,
  /// la validation passe donc obligatoirement par le bouton "J'AI COMPRIS".
  Future<void> _validateWhatsAppWarning() async {
    if (_isMobileMoney) {
      await WhatsappWarningModal.show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.type != null) {
      _type = widget.type;
      _prefill();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validateWhatsAppWarning().then((_) => _loadCountryAndOperators());
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _promptTypeChoice());
    }
  }

  Future<void> _promptTypeChoice() async {
    final chosen = await AddPaymentAccountScreen.show(context);
    if (!mounted) return;
    if (chosen == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _type = chosen;
      _loadingCountry = true;
    });
    _prefill();
    await _validateWhatsAppWarning();
    if (!mounted) return;
    await _loadCountryAndOperators();
  }

  void _prefill() {
    final pref = widget.currentPaymentPreference;
    if (pref == null) return;
    _phoneController.text = pref.detailPhone ?? '';
    _firstNameController.text = _splitFullName(pref.detailName ?? '').firstName;
    _lastNameController.text = _splitFullName(pref.detailName ?? '').lastName;
    _ibanController.text = pref.detailIban ?? '';
    _bankNameController.text = pref.detailBankName ?? '';
    _swiftController.text = pref.detailBic ?? '';
  }

  Future<void> _loadCountryAndOperators() async {
    try {
      final user = await Modular.get<GetCurrentUserUseCase>().call(NoParms());
      _country = CountryCode.tryFromCountryCode(user.pays.toUpperCase()) ??
          CountryCode.fromCountryCode('CM');
    } catch (_) {
      _country = CountryCode.fromCountryCode('CM');
    }
    if (_isMobileMoney) {
      try {
        final payoutMethods =
            await Modular.get<GetPayoutMethodsUseCase>().call(NoParms());
        _operators = payoutMethods.mobileMoneyOperators;
      } catch (err) {
        debugPrint('[PaymentAccountFormScreen] payout methods error: $err');
        _operators = [];
      }
    }
    if (!mounted) return;
    setState(() => _loadingCountry = false);
  }

  ({String firstName, String lastName}) _splitFullName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return (firstName: parts[0], lastName: '');
    return (firstName: parts.first, lastName: parts.sublist(1).join(' '));
  }

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

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobController.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  String get _fullPhoneNumber =>
      '${(_country!.dialCode ?? '')}${_phoneController.text.trim()}';

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
    final accountHolder = (
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      birthdate: _dob!,
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
    if (_dob == null) return;

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
              if (Modular.to.canPop()) {
                Modular.to.pop();
              } else {
                Modular.get<WalletRoutes>().home.navigate();
              }
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
            if (Modular.to.canPop()) {
              Modular.to.pop();
            } else {
              Modular.get<WalletRoutes>().home.navigate();
            }
          },
          handleResend: (context) {
            return Modular.get<
                    ResendPaymentPreferencesVerificationCodeUseCase>()
                .call(NoParms());
          },
        ).show(context);
      }
      // return;
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    _swiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: _textPrimary),
        title: Text(
          LocaleKeys.wallet_module_payment_account_title.tr().toUpperCase(),
          style: _appBarTitle,
        ),
      ),
      body: _type == null
          ? const SizedBox.shrink()
          : _loadingCountry
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: _bg,
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: SafeArea(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                          children: [
                            Text(
                              LocaleKeys.wallet_module_payment_account_title
                                  .tr(),
                              style: _h1,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              LocaleKeys
                                  .wallet_module_payment_account_description
                                  .tr(),
                              style: _body,
                            ),
                            const SizedBox(height: 24),
                            _PremiumTypeField(
                              label: LocaleKeys
                                  .wallet_module_payment_account_account_type
                                  .tr(),
                              value: _isMobileMoney
                                  ? LocaleKeys
                                      .wallet_module_payment_account_mobile_payment
                                      .tr()
                                  : LocaleKeys
                                      .wallet_module_payment_account_bank_account
                                      .tr(),
                            ),
                            if (_isMobileMoney) ..._mobileMoneyFields(),
                            if (!_isMobileMoney) _bankTopFields(),
                            const Divider(height: 8, color: _divider),
                            const SizedBox(height: 12),
                            _PremiumTextField(
                              label: LocaleKeys.wallet_module_common_first_name
                                  .tr(),
                              controller: _firstNameController,
                              validator: _requiredValidator,
                            ),
                            _PremiumTextField(
                              label: LocaleKeys.wallet_module_common_last_name
                                  .tr(),
                              controller: _lastNameController,
                              validator: _requiredValidator,
                            ),
                            _PremiumTextField(
                              label: LocaleKeys.wallet_module_common_birthdate
                                  .tr(),
                              controller: _dobController,
                              hint: LocaleKeys
                                  .wallet_module_payment_account_date_hint
                                  .tr(),
                              readOnly: true,
                              onTap: _pickDob,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? LocaleKeys
                                      .wallet_module_payment_account_update_required
                                      .tr()
                                  : null,
                            ),
                            if (_isMobileMoney) ...[
                              const SizedBox(height: 8),
                              const Divider(height: 8, color: _divider),
                              const SizedBox(height: 12),
                            ],
                            if (!_isMobileMoney)
                              _PremiumLockedField(
                                label: LocaleKeys.wallet_module_common_country
                                    .tr(),
                                child: Row(
                                  children: [
                                    Text(
                                      _flagEmoji(_country!.code ?? ''),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _country!.name ?? '',
                                      style: _fieldValue,
                                    ),
                                  ],
                                ),
                              ),
                            _PremiumTextField(
                              label:
                                  LocaleKeys.wallet_module_common_street.tr(),
                              controller: _streetController,
                              hint: LocaleKeys
                                  .wallet_module_payment_account_full_address_hint
                                  .tr(),
                              validator: _requiredValidator,
                            ),
                            _PremiumTextField(
                              label: LocaleKeys.wallet_module_common_city.tr(),
                              controller: _cityController,
                              validator: _requiredValidator,
                            ),
                            _PremiumTextField(
                              label: LocaleKeys.wallet_module_common_postal_code
                                  .tr(),
                              controller: _postalCodeController,
                              validator: _requiredValidator,
                            ),
                            const SizedBox(height: 8),
                            _PremiumUploadField(
                              title: LocaleKeys
                                  .wallet_module_payment_account_load_bank_docs
                                  .tr(),
                              fileName: _documentName,
                              onPickFile: _pickDocument,
                            ),
                            const SizedBox(height: 28),
                            ActionButton(
                              text: LocaleKeys.wallet_module_common_save.tr(),
                              isLoading: _submitting,
                              backgroundColor: Colors.black,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

  List<Widget> _mobileMoneyFields() {
    return [
      _PremiumLockedField(
        label: LocaleKeys.wallet_module_common_country.tr(),
        child: Row(
          children: [
            Text(
              _flagEmoji(_country!.code ?? ''),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Text(_country!.name ?? '', style: _fieldValue),
          ],
        ),
      ),
      _PremiumDropdownField<PayoutOperatorEntity>(
        label:
            LocaleKeys.wallet_module_payment_account_mobile_operator_name.tr(),
        hint: _operators.isEmpty
            ? LocaleKeys.wallet_module_payment_account_update_no_operator.tr()
            : LocaleKeys.wallet_module_payment_account_update_operator_hint
                .tr(),
        value: _selectedOperator,
        enabled: _operators.isNotEmpty,
        items: _operators
            .map((op) => DropdownMenuItem(value: op, child: Text(op.name)))
            .toList(),
        onChanged: (op) => setState(() => _selectedOperator = op),
        validator: (op) => op == null
            ? LocaleKeys.wallet_module_payment_account_update_operator_required
                .tr()
            : null,
      ),
      Text(
        LocaleKeys.wallet_module_payment_account_account_number
            .tr()
            .toUpperCase(),
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
            child: Text(_country!.dialCode ?? '', style: _fieldValue),
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
                fillColor: _fieldFill,
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
      const SizedBox(height: 18),
    ];
  }

  Widget _bankTopFields() {
    return Column(
      children: [
        _PremiumTextField(
          label: LocaleKeys.wallet_module_payment_account_account_number.tr(),
          controller: _ibanController,
          hint: LocaleKeys.wallet_module_common_iban.tr(),
          validator: _requiredValidator,
        ),
        _PremiumTextField(
          label: LocaleKeys.wallet_module_payment_account_bank_name.tr(),
          controller: _bankNameController,
          hint: LocaleKeys.wallet_module_payment_account_bank_name_hint.tr(),
          validator: _requiredValidator,
        ),
        _PremiumTextField(
          label: LocaleKeys.wallet_module_payment_account_swift_code.tr(),
          controller: _swiftController,
          hint: LocaleKeys.wallet_module_payment_account_bic_swift_hint.tr(),
        ),
      ],
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const _PremiumTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.readOnly = false,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _fieldLabel),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          style: _fieldValue,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _fieldHint,
            filled: true,
            fillColor: _fieldFill,
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
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _PremiumLockedField extends StatelessWidget {
  final String label;
  final Widget child;

  const _PremiumLockedField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 14),
      ],
    );
  }
}

/// Read-only "account type" field, styled to look like a dropdown (chevron
/// included) to match the design, even though the value is fixed by the
/// screen's [EAccountType] and therefore not actually selectable.
class _PremiumTypeField extends StatelessWidget {
  final String label;
  final String value;

  const _PremiumTypeField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 14),
      ],
    );
  }
}

class _PremiumDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final bool enabled;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  const _PremiumDropdownField({
    required this.label,
    required this.hint,
    required this.items,
    this.value,
    this.enabled = true,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _fieldLabel),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _fieldHint,
            filled: true,
            fillColor: enabled ? _fieldFill : _fieldFillDisabled,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
          items: items,
          onChanged: enabled ? onChanged : null,
          validator:
              enabled ? (v) => validator == null ? null : validator!(v) : null,
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

/// Upload card matching the premium design: dashed rounded border, a circular
/// icon, a title, a short hint about accepted formats/size, and a pill-shaped
/// "UPLOAD +" button that triggers [onPickFile].
class _PremiumUploadField extends StatelessWidget {
  final String title;
  final String? fileName;
  final VoidCallback onPickFile;

  const _PremiumUploadField({
    required this.title,
    required this.onPickFile,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;
    return CustomPaint(
      painter: const _DashedRRectPainter(
        radius: 20,
        borderColor: _divider,
        fillColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: _fieldFillDisabled,
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFile
                    ? Icons.check_circle_outline
                    : Icons.file_upload_outlined,
                color: hasFile ? _primaryButton : _textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              hasFile ? fileName! : title,
              textAlign: TextAlign.center,
              style: _fieldValue,
            ),
            if (!hasFile) ...[
              const SizedBox(height: 6),
              Text(
                LocaleKeys.wallet_module_payment_account_doc_formats_hint.tr(),
                textAlign: TextAlign.center,
                style: _uploadHint,
              ),
            ],
            const SizedBox(height: 16),
            _UploadPillButton(
              label: hasFile
                  ? LocaleKeys.wallet_module_payment_account_update_change.tr()
                  : LocaleKeys.wallet_module_payment_account_update_upload_cta
                      .tr(),
              onTap: onPickFile,
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadPillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _UploadPillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: _fieldFillDisabled,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: _textPrimary,
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final double radius;
  final Color borderColor;
  final Color fillColor;

  const _DashedRRectPainter({
    required this.radius,
    required this.borderColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    canvas.drawRRect(rrect, Paint()..color = fillColor);

    final dashedPath = _dashPath(
      Path()..addRRect(rrect),
      dashLength: 6,
      gapLength: 5,
    );
    canvas.drawPath(
      dashedPath,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  Path _dashPath(
    Path source, {
    required double dashLength,
    required double gapLength,
  }) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final segmentLength = draw ? dashLength : gapLength;
        final next = (distance + segmentLength).clamp(0.0, metric.length);
        if (draw) {
          dest.addPath(metric.extractPath(distance, next), Offset.zero);
        }
        distance = next;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.radius != radius;
}
