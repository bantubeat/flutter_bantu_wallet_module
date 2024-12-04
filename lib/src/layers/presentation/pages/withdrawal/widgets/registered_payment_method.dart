import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';

typedef _PaymentPreferenceSumary = ({
  String? name,
  String? accountName,
  String? id,
  Color color,
});

class RegisteredPaymentMethod extends StatelessWidget {
  final PaymentPreferenceEntity paymentPreference;

  const RegisteredPaymentMethod({
    required this.paymentPreference,
    super.key,
  });

  _PaymentPreferenceSumary? _getSumary() {
    switch (paymentPreference.accountType) {
      case 'Paypal':
        return (
          name: 'Paypal',
          accountName: '',
          id: paymentPreference.detailEmail,
          color: Color(0xFF004A9D),
        );

      case 'BankTransfer':
        return (
          name: paymentPreference.detailBankName,
          accountName: paymentPreference.detailName,
          id: paymentPreference.detailIban,
          color: Color(0xFFE91D25),
        );

      case 'Mobile':
        return (
          name: paymentPreference.detailOperator,
          accountName: paymentPreference.detailName,
          id: paymentPreference.detailPhone,
          color: Color(0xFFFCCC37),
        );

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _getSumary();
    final accountType = summary?.name ?? paymentPreference.accountType;
    final accountId = (summary?.id ?? paymentPreference.detailName ?? '');
    final accountName = summary?.accountName;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                accountId.replaceFirst(
                  RegExp(r'[a-zA-Z1-9]'),
                  '*',
                  (accountId.length * 0.3).toInt(),
                ),
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
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.edit_square,
              size: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
