import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../../../core/generated/locale_keys.g.dart';

class AccountSwitcher extends StatelessWidget {
  final AccountType accountType;
  final void Function(AccountType accountType) onSelect;

  const AccountSwitcher({
    required this.accountType,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            blurRadius: 40,
            offset: const Offset(0.0, 80.0),
            color: Colors.grey.shade50,
          ),
        ],
      ),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: _buildPaymentTab(
              label: LocaleKeys
                  .wallet_module_transaction_history_page_financial_account
                  .tr(),
              icon: Icon(
                Ionicons.wallet_outline,
                size: 25,
                color: accountType == AccountType.payment
                    ? Colors.black
                    : Colors.grey,
              ),
              isSelected: accountType == AccountType.payment,
              onTap: () => onSelect(AccountType.payment),
            ),
          ),
          Expanded(
            child: _buildPaymentTab(
              label: LocaleKeys
                  .wallet_module_transaction_history_page_financial_account
                  .tr(),
              icon: Icon(
                Ionicons.wallet_outline,
                size: 25,
                color: accountType == AccountType.revenue
                    ? Colors.black
                    : Colors.grey,
              ),
              isSelected: accountType == AccountType.revenue,
              onTap: () => onSelect(AccountType.revenue),
            ),
          ),
          Expanded(
            child: _buildPaymentTab(
              label: LocaleKeys
                  .wallet_module_transaction_history_page_beatzocoin_account
                  .tr(),
              icon: Container(
                width: 25,
                height: 25,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: accountType == AccountType.bzc
                        ? Colors.black
                        : Colors.grey,
                  ),
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  child: Text(
                    'BZC',
                    style: TextStyle(
                      fontSize: 12,
                      color: accountType == AccountType.bzc
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              isSelected: accountType == AccountType.bzc,
              onTap: () => onSelect(AccountType.bzc),
            ),
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: isSelected ? BorderRadius.circular(18) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.left,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
