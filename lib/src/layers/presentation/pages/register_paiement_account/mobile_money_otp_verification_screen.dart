import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';

import 'otp_result_screen.dart';
import 'widgets/otp_code_input.dart';

// Same "premium" design tokens used across the payment-account flow.
const _bg = Color(0xFFF8F8FC);
const _textPrimary = Color(0xFF1A1A2E);
const _textSecondary = Color(0xFF6B7280);
const _fieldFillDisabled = Color(0xFFECEDF1);
const _primaryButton = Color(0xFF0F1F4B);

const _sectionTitle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w800,
  color: _textPrimary,
);
const _body = TextStyle(
  fontSize: 14,
  height: 1.5,
  color: _textSecondary,
);
const _bodyStrong = TextStyle(
  fontSize: 14,
  height: 1.5,
  fontWeight: FontWeight.w700,
  color: _textPrimary,
);
const _appBarTitle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w800,
  color: _textPrimary,
);
const _pillLabel = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.6,
  color: _textSecondary,
);
const _resendLabel = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.6,
  color: _primaryButton,
);

/// "Vérification" — verifies that the mobile-money phone number really
/// belongs to the user, since it can differ from the number used for account
/// authentication.
class MobileMoneyOtpVerificationScreen extends StatefulWidget {
  final String fullPhoneNumber;
  final Future<bool> Function(String code) onVerify;
  final Future<void> Function()? onResend;

  const MobileMoneyOtpVerificationScreen({
    required this.fullPhoneNumber,
    required this.onVerify,
    this.onResend,
    super.key,
  });

  @override
  State<MobileMoneyOtpVerificationScreen> createState() =>
      _MobileMoneyOtpVerificationScreenState();
}

class _MobileMoneyOtpVerificationScreenState
    extends State<MobileMoneyOtpVerificationScreen> {
  String _code = '';
  bool _verifying = false;
  bool _resending = false;

  String get _maskedPhone {
    final p = widget.fullPhoneNumber;
    if (p.length < 7) return p;
    final visibleStart = p.substring(0, p.length - 6);
    final visibleEnd = p.substring(p.length - 2);
    return '$visibleStart•• •• ••$visibleEnd';
  }

  Future<void> _confirm() async {
    if (_code.length < 6 || _verifying) return;
    setState(() => _verifying = true);
    late final bool success;
    try {
      success = await widget.onVerify(_code);
    } catch (_) {
      success = false;
    }
    if (!mounted) return;
    setState(() => _verifying = false);

    if (success) {
      final proceed = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => OtpResultScreen(
            success: true,
            title: LocaleKeys
                .wallet_module_payment_account_otp_result_success_title
                .tr(),
            message: LocaleKeys
                .wallet_module_payment_account_otp_result_success_message
                .tr(),
            primaryLabel: LocaleKeys
                .wallet_module_payment_account_otp_result_success_cta
                .tr(),
            onPrimaryPressed: () => Navigator.of(context).pop(true),
          ),
        ),
      );
      if (!mounted) return;
      if (proceed == true) Navigator.of(context).pop(true);
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpResultScreen(
            success: false,
            title: LocaleKeys
                .wallet_module_payment_account_otp_result_failure_title
                .tr(),
            message: LocaleKeys
                .wallet_module_payment_account_otp_result_failure_message
                .tr(),
            primaryLabel: LocaleKeys
                .wallet_module_payment_account_otp_result_failure_cta
                .tr(),
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  Future<void> _resend() async {
    if (_resending) return;
    setState(() => _resending = true);
    final handler = widget.onResend;
    try {
      if (handler != null) await handler();
      if (!mounted) return;
      UiAlertHelpers.showSuccessToast(
        LocaleKeys.wallet_module_payment_account_otp_phone_code_resent.tr(),
      );
    } catch (_) {
      if (!mounted) return;

      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_payment_account_send_otp_failed.tr(),
      );
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  List<TextSpan> _descriptionSpans() {
    final full = LocaleKeys.wallet_module_payment_account_otp_phone_description
        .tr(namedArgs: {'phone': _maskedPhone});
    final index = full.indexOf(_maskedPhone);
    if (index < 0) return [TextSpan(text: full, style: _body)];
    return [
      TextSpan(text: full.substring(0, index), style: _body),
      TextSpan(text: _maskedPhone, style: _bodyStrong),
      TextSpan(text: full.substring(index + _maskedPhone.length), style: _body),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 4,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _fieldFillDisabled,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 18,
                color: _textPrimary,
              ),
            ),
          ),
        ),
        title: Text(
          LocaleKeys.wallet_module_payment_account_otp_phone_title.tr(),
          style: _appBarTitle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                LocaleKeys.wallet_module_payment_account_otp_phone_title.tr(),
                style: _sectionTitle,
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(children: _descriptionSpans()),
              ),
              const SizedBox(height: 32),
              OtpCodeInput(
                onChanged: (v) => setState(() => _code = v),
                onCompleted: (_) => _confirm(),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton.icon(
                  onPressed: _resending ? null : _resend,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(
                    Icons.refresh,
                    size: 16,
                    color: _primaryButton,
                  ),
                  label: Text(
                    LocaleKeys.wallet_module_payment_account_otp_phone_resend
                        .tr()
                        .toUpperCase(),
                    style: _resendLabel,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: _fieldFillDisabled,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: _textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        LocaleKeys
                            .wallet_module_payment_account_otp_phone_encryption
                            .tr()
                            .toUpperCase(),
                        style: _pillLabel,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ActionButton(
                text: LocaleKeys.wallet_module_payment_account_otp_phone_confirm
                    .tr(),
                isLoading: _verifying,
                enabled: _code.length == 6,
                backgroundColor: Colors.black,
                onPressed: _confirm,
                fullWidth: true,
                borderRadius: BorderRadius.circular(25),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
