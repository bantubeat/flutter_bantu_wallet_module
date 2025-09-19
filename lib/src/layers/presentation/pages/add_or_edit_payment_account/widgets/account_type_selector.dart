import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

class AccountTypeSelector extends StatelessWidget {
  final EAccountType selectedAccountType;
  final void Function(EAccountType) onSelectAccountType;

  const AccountTypeSelector({
    required this.onSelectAccountType,
    required this.selectedAccountType,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = selectedAccountType == EAccountType.mobile;
    return GestureDetector(
      onTap: () => _showAccountTypeModal(context, onSelectAccountType),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isMobile
                    ? LocaleKeys.wallet_module_payment_account_mobile_payment
                        .tr()
                    : LocaleKeys.wallet_module_payment_account_bank_account
                        .tr(),
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccountTypeModal(
    BuildContext context,
    void Function(EAccountType) onSelectAccountType,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.wallet_module_payment_account_account_type.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _OptionModal(
                icon: Icons.phone_android,
                title: LocaleKeys.wallet_module_payment_account_mobile_payment
                    .tr(),
                subtitle: LocaleKeys
                    .wallet_module_payment_account_mobile_payment_way
                    .tr(),
                onTap: () {
                  onSelectAccountType(EAccountType.mobile);
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 24),
              _OptionModal(
                icon: Icons.account_balance,
                title:
                    LocaleKeys.wallet_module_payment_account_bank_account.tr(),
                subtitle: LocaleKeys
                    .wallet_module_payment_account_bank_account_way
                    .tr(),
                onTap: () {
                  onSelectAccountType(EAccountType.bankTransfer);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OptionModal extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionModal({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 30, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
