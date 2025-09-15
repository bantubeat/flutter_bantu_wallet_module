import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/check_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/resend_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VerificationCodeModal extends StatefulWidget {
  const VerificationCodeModal({super.key});

  @override
  State<VerificationCodeModal> createState() => _VerificationCodeModalState();

  // A static method to show the modal
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return const VerificationCodeModal();
      },
    );
  }
}

class _VerificationCodeModalState extends State<VerificationCodeModal> {
  final textCtrl = TextEditingController(text: '');
  bool _resendingCode = false;
  bool _submitting = false;

  void _onResentCode() async {
    setState(() => _resendingCode = true);
    try {
      await Modular.get<ResendPaymentPreferencesVerificationCodeUseCase>()
          .call(NoParms());
    } catch (_) {
      if (!mounted) return;

      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_an_error_occur.tr(),
      );
    } finally {
      setState(() => _resendingCode = false);
    }
  }

  void _onSubmit() async {
    final code = textCtrl.text;
    if (code.isEmpty) {
      return UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_field_required
            .tr(namedArgs: {'field': 'code'}),
      );
    }

    setState(() => _submitting = true);

    try {
      final result =
          await Modular.get<CheckPaymentPreferencesverificationCodeUseCase>()
              .call(code);

      if (!result || !mounted) return;

      Navigator.pop(context, result);
      Modular.get<WalletRoutes>().withdrawal.navigate();
    } catch (_) {
      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_an_error_occur.tr(),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.wallet_module_payment_account_modal_title.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              LocaleKeys.wallet_module_payment_account_modal_description.tr(),
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              LocaleKeys.wallet_module_payment_account_modal_code_placeholder
                  .tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: textCtrl,
              validator: (val) => null,
              decoration: InputDecoration(
                hintText: 'k5w000',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: !_resendingCode,
                replacement: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: TextButton(
                  onPressed: _onResentCode,
                  child: Text(
                    LocaleKeys.wallet_module_payment_account_modal_resend_code
                        .tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ActionButton(
              isLoading: _submitting,
              text: LocaleKeys.wallet_module_common_validate.tr(),
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
