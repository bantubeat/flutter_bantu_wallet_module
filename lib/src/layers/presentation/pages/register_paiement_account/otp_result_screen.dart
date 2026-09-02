import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';

class OtpResultScreen extends StatelessWidget {
  final bool success;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;

  /// Only shown on success, under the primary button.
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  const OtpResultScreen({
    required this.success,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
    super.key,
  });

  static const _ink = Color(0xFF1E2124);
  static const _errorRed = Color(0xFFC0392B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment:
                success ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              if (success)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'FEATLINK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: _ink,
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close, color: Colors.black87),
                  ),
                ),
              const Spacer(),
              Center(
                child: success ? _buildSuccessIcon() : _buildFailureIcon(),
              ),
              const Spacer(),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: success ? TextAlign.center : TextAlign.left,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: success ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const Spacer(),
              ActionButton(
                text: primaryLabel,
                onPressed: onPrimaryPressed,
                borderRadius: BorderRadius.circular(25),
                fullWidth: true,
              ),
              if (success) ...[
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: onSecondaryPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                    child: Text(
                      (secondaryLabel ??
                              LocaleKeys
                                  .wallet_module_payment_account_explore_features
                                  .tr())
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.help_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys
                                  .wallet_module_payment_account_otp_help_title
                                  .tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              LocaleKeys
                                  .wallet_module_payment_account_otp_help_message
                                  .tr(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!success) ...[
                      Icon(
                        Icons.verified_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      LocaleKeys.wallet_module_payment_account_otp_secured_by
                          .tr(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x14000000), Color(0x00000000)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              color: _ink,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  /// Two overlapping soft blurred blobs with a red X circle centered on top.
  Widget _buildFailureIcon() {
    return SizedBox(
      width: 150,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 10,
            child: _blob(70, const Color(0x33E0A0A0)),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: _blob(60, Colors.grey.withValues(alpha: 0.2)),
          ),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: _errorRed, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 40, spreadRadius: 30),
        ],
      ),
    );
  }
}
