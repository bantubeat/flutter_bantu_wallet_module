import 'package:flutter/material.dart';

class AccountTypeModal extends StatelessWidget {
  final ValueChanged<AccountType>? onSelected;

  const AccountTypeModal({super.key, this.onSelected});

  static Future<AccountType?> show(
    BuildContext context, {
    ValueChanged<AccountType>? onSelected,
  }) {
    return showModalBottomSheet<AccountType>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AccountTypeModal(onSelected: onSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Choisir votre type de compte',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _AccountTypeTile(
              icon: Icons.person,
              label: 'Particulier',
              enabled: true,
              onTap: () {
                onSelected?.call(AccountType.particulier);
                Navigator.of(context).pop(AccountType.particulier);
              },
            ),
            const Divider(height: 1),
            const _AccountTypeTile(
              icon: Icons.account_balance,
              label: 'Entreprise',
              enabled: false,
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}

enum AccountType { particulier, entreprise }

extension AccountTypeX on AccountType {
  bool get isCompany => this == AccountType.entreprise;
}

class _AccountTypeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  const _AccountTypeTile({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color contentColor = enabled ? Colors.black87 : Colors.grey.shade400;
    final Color iconBgColor = Colors.grey.shade200;
    final Color iconColor =
        enabled ? Colors.grey.shade800 : Colors.grey.shade400;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: iconBgColor,
              child: Icon(icon, size: 26, color: iconColor),
            ),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(fontSize: 16, color: contentColor)),
          ],
        ),
      ),
    );
  }
}
