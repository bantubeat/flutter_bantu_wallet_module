import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_modular/flutter_modular.dart';

typedef _PaymentPreferenceSumary = ({
  String? name,
  String? accountName,
  String? id,
  Color color,
});

class RegisteredPaymentMethod extends StatelessWidget {
  final PaymentPreferenceEntity paymentPreference;

  const RegisteredPaymentMethod(this.paymentPreference);

  void _onEdit() {
    Modular.get<WalletRoutes>().addOrEditPaymentAccount.push(paymentPreference);
  }

  _PaymentPreferenceSumary _getSumary() {
    switch (paymentPreference.accountType) {
      case EAccountType.paypal:
        return (
          name: 'Paypal',
          accountName: '',
          id: paymentPreference.detailEmail,
          color: const Color(0xFF004A9D),
        );

      case EAccountType.bankTransfer:
        return (
          name: paymentPreference.detailBankName,
          accountName: paymentPreference.detailName,
          id: paymentPreference.detailIban,
          color: const Color(0xFFE91D25),
        );

      case EAccountType.mobile:
        return (
          name: paymentPreference.detailOperator,
          accountName: paymentPreference.detailName,
          id: paymentPreference.detailPhone,
          color: const Color(0xFFFCCC37),
        );
    }
  }

  String _maskAccountId(String accountId) {
    final length = accountId.length;
    final maskLength = (length * 0.7).toInt();
    return ('*' * maskLength) + accountId.substring(maskLength);
  }

  @override
  Widget build(BuildContext context) {
    final summary = _getSumary();
    final accountType = summary.name ?? paymentPreference.accountType.value;
    final accountId = (summary.id ?? paymentPreference.detailName ?? '');
    final accountName = summary.accountName;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _maskAccountId(accountId),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  accountName ?? '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: _onEdit,
                icon: const Icon(
                  Icons.edit_square,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
