import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';

/// Écran "Validation Sécurisée" — saisie du code OTP envoyé par mail
/// avant de confirmer une demande de retrait.
class OtpValidationScreen extends StatefulWidget {
  final String accountName;
  final String? accountAvatarUrl;
  final int codeLength;
  final ValueChanged<String> onSubmit;
  final VoidCallback onResendCode;

  const OtpValidationScreen({
    required this.accountName,
    required this.onSubmit,
    required this.onResendCode,
    this.accountAvatarUrl,
    this.codeLength = 6,
    super.key,
  });

  @override
  State<OtpValidationScreen> createState() => _OtpValidationScreenState();
}

class _OtpValidationScreenState extends State<OtpValidationScreen> {
  static const _ink = Color(0xFF23292C);
  static const _focusBlue = Color(0xFF3B82F6);

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _resending = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.codeLength, (_) => FocusNode());
    // Focus automatiquement la première case au chargement de l'écran.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  bool get _isComplete => _code.length == widget.codeLength;

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index + 1 < widget.codeLength) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() {});
    }
  }

  Future<void> _handleResend() async {
    if (_resending) return;
    setState(() => _resending = true);
    widget.onResendCode();
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _resending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildAccountRow(),
                    const SizedBox(height: 28),
                    Text(
                      LocaleKeys
                          .wallet_module_withdrawal_process_otp_code_secure_validation
                          .tr(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      LocaleKeys
                          .wallet_module_withdrawal_process_otp_code_description
                          .tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildOtpFields(),
                    const SizedBox(height: 20),
                    _buildResendButton(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: ActionButton(
                text:
                    LocaleKeys.wallet_module_withdrawal_process_otp_code_confirm_withdrawal
                        .tr(),
                onPressed: _isComplete ? () => widget.onSubmit(_code) : (){},
                borderRadius: BorderRadius.circular(25),
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          const SizedBox(width: 4),
          Text(
            LocaleKeys.wallet_module_withdrawal_page_title.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[200],
          backgroundImage: widget.accountAvatarUrl != null
              ? NetworkImage(widget.accountAvatarUrl!)
              : null,
          child: widget.accountAvatarUrl == null
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.wallet_module_withdrawal_process_otp_code_account_of
                  .tr(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.accountName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.codeLength, (index) {
        return _buildOtpBox(index);
      }),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48,
      height: 60,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (event) => _onKeyEvent(index, event),
        child: AnimatedBuilder(
          animation: _focusNodes[index],
          builder: (context, _) {
            final isFocused = _focusNodes[index].hasFocus;
            final hasValue = _controllers[index].text.isNotEmpty;
            return Container(
              decoration: BoxDecoration(
                color: isFocused
                    ? _focusBlue.withValues(alpha: 0.08)
                    : const Color(0xFFEBEBEC),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isFocused ? _focusBlue : Colors.transparent,
                  width: 1.4,
                ),
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                obscureText: hasValue,
                obscuringCharacter: '●',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (value) => _onChanged(index, value),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResendButton() {
    return Center(
      child: TextButton.icon(
        onPressed: _resending ? null : _handleResend,
        icon: _resending
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.refresh, size: 16, color: Colors.grey[700]),
        label: Text(
          LocaleKeys.wallet_module_withdrawal_process_otp_code_resend_code
              .tr(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}