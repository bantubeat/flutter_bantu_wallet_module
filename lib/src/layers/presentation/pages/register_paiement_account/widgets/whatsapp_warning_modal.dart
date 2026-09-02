import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/api_constants.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

class WhatsappWarningModal extends StatelessWidget {
  const WhatsappWarningModal({super.key});

  /// Ouvre le modal d'avertissement WhatsApp. Il ne peut être fermé qu'en
  /// validant avec le bouton "J'AI COMPRIS" ; retourne `true` si validé.
  static Future<bool> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => const WhatsappWarningModal(),
    ).then((validated) => validated ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône WhatsApp
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(ApiConstants.whatsaapImg),
              ),
              const SizedBox(height: 20),

              // Titre
              Text(
                LocaleKeys.wallet_module_payment_account_whatsapp_warning_title
                    .tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                LocaleKeys
                    .wallet_module_payment_account_whatsapp_warning_description
                    .tr(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Bloc info sécurité
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 20,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        LocaleKeys
                            .wallet_module_payment_account_whatsapp_warning_security
                            .tr(),
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey[700],
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bouton
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    LocaleKeys
                        .wallet_module_payment_account_whatsapp_warning_cta
                        .tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
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
}
