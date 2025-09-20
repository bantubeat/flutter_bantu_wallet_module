import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';

class OtpCodeModal extends StatefulWidget {
  final String title;
  final String description;
  final Future<void> Function(BuildContext, String) handleSubmit;
  final Future<void> Function(BuildContext)? handleResend;

  const OtpCodeModal({
    required this.title,
    required this.description,
    required this.handleSubmit,
    this.handleResend,
    super.key,
  });

  @override
  State<OtpCodeModal> createState() => _OtpCodeModalState();

  // A static method to show the modal
  Future<dynamic> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (_) => this,
    );
  }
}

class _OtpCodeModalState extends State<OtpCodeModal> {
  final textCtrl = TextEditingController(text: '');
  bool _resendingCode = false;
  bool _submitting = false;

  void _onResentCode() async {
    final handler = widget.handleResend;
    if (handler == null) return;
    setState(() => _resendingCode = true);
    try {
      await handler(context);
    } catch (_) {
      if (!mounted) return;

      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_an_error_occur.tr(),
      );
    } finally {
      if (mounted) setState(() => _resendingCode = false);
    }
  }

  void _onSubmit() async {
    final code = textCtrl.text;
    if (code.isEmpty) {
      return UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_field_required.tr(
          namedArgs: {'field': 'code'},
        ),
      );
    }

    setState(() => _submitting = true);

    try {
      await widget.handleSubmit(context, code);
    } catch (_) {
      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_common_an_error_occur.tr(),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
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
                Flexible(
                  child: FittedBox(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
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
              widget.description,
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
                hintText: '123456',
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
