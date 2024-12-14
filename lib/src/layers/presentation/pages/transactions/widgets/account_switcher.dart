import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../../../core/generated/locale_keys.g.dart';

class AccountSwitcher extends StatelessWidget {
  final bool isBzcAccount;
  final VoidCallback onSelectFiatAccount;
  final VoidCallback onSelectBzcAccount;

  const AccountSwitcher({
    required this.isBzcAccount,
    required this.onSelectFiatAccount,
    required this.onSelectBzcAccount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            blurRadius: 40,
            offset: Offset(0.0, 80.0),
            color: Colors.grey.shade50,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPaymentTab(
              label: LocaleKeys
                  .wallet_module_transaction_history_page_financial_account
                  .tr(),
              icon: Icon(
                Ionicons.wallet_outline,
                size: 30,
                color: !isBzcAccount ? Colors.black : Colors.grey,
              ),
              isSelected: !isBzcAccount,
              onTap: onSelectFiatAccount,
            ),
          ),
          const SizedBox(width: 10),
          _buildPaymentTab(
            label: LocaleKeys
                .wallet_module_transaction_history_page_beatzocoin_account
                .tr(),
            icon: Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: isBzcAccount ? Colors.black : Colors.grey,
                ),
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Text(
                  'BZC',
                  style: TextStyle(
                    color: isBzcAccount ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            isSelected: isBzcAccount,
            onTap: onSelectBzcAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTab({
    required String label,
    required Widget icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: isSelected ? BorderRadius.circular(12) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 8),
            Text(
              label,
              textAlign: TextAlign.left,
              softWrap: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
