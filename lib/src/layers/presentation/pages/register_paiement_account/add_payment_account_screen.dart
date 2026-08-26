import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

const _bg = Color(0xFFF8F8FC);
const _textPrimary = Color(0xFF1A1A2E);
const _textSecondary = Color(0xFF6B7280);
const _divider = Color(0xFFE5E7EB);

/// "Ajouter un Compte de paiement" — modal de choix du type de compte.
///
/// Affiché à l'arrivée sur [PaymentAccountFormScreen]. Le choix est
/// obligatoire pour continuer : le modal n'est ni fermable par l'extérieur
/// ni par glissement, et renvoie le type sélectionné via [show].
class AddPaymentAccountScreen extends StatelessWidget {
  const AddPaymentAccountScreen({super.key});

  /// Ouvre le modal et renvoie le type choisi, ou `null` si l'utilisateur a
  /// renoncé (retour système).
  static Future<EAccountType?> show(BuildContext context) {
    return showModalBottomSheet<EAccountType>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: _bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddPaymentAccountScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.wallet_module_payment_account_title.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.wallet_module_payment_account_description.tr(),
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            _AccountTypeTile(
              icon: Icons.phone_android,
              title:
                  LocaleKeys.wallet_module_payment_account_mobile_payment.tr(),
              subtitle: LocaleKeys
                  .wallet_module_payment_account_mobile_payment_way
                  .tr(),
              onTap: () => Navigator.of(context).pop(EAccountType.mobile),
            ),
            const Divider(height: 32, color: _divider),
            _AccountTypeTile(
              icon: Icons.account_balance,
              title: LocaleKeys.wallet_module_payment_account_bank_account.tr(),
              subtitle: LocaleKeys
                  .wallet_module_payment_account_bank_account_way
                  .tr(),
              onTap: () => Navigator.of(context).pop(EAccountType.bankTransfer),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountTypeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey[200],
              child: Icon(icon, size: 26, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}
