import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

class IncompleteProfileModal extends StatelessWidget {
  final String title;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onComplete;
  final VoidCallback? onLater;

  const IncompleteProfileModal({
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onComplete,
    this.onLater,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onComplete,
    String? title,
    String? description,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onLater,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: true,
      builder: (context) => IncompleteProfileModal(
        title: title ??
            LocaleKeys.wallet_module_incomplete_profile_modal_title.tr(),
        description: description ??
            LocaleKeys.wallet_module_incomplete_profile_modal_description.tr(),
        primaryButtonText: primaryButtonText ??
            LocaleKeys.wallet_module_incomplete_profile_modal_primary_button
                .tr(),
        secondaryButtonText: secondaryButtonText ??
            LocaleKeys.wallet_module_incomplete_profile_modal_secondary_button
                .tr(),
        onComplete: onComplete,
        onLater: onLater,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône profil incomplet
            SizedBox(
              width: 76,
              height: 76,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDEDED),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF9AA0A8),
                      size: 38,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_rounded,
                        color: Color(0xFF9AA0A8),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14.5,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onComplete();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2430),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  primaryButtonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            TextButton(
              onPressed: () {
                onLater?.call();
              },
              child: Text(
                secondaryButtonText,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
