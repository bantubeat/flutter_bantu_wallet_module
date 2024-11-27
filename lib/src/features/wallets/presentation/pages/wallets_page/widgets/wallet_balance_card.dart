
import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  final String financialBalance;
  final String beatzcoinBalance;
  final String financialAccountId;
  final String beatzcoinAccountId;

  const WalletBalanceCard({
    required this.financialBalance,
    required this.beatzcoinBalance,
    required this.financialAccountId,
    required this.beatzcoinAccountId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceSection(
            'Compte Financier',
            financialBalance,
            financialAccountId,
          ),
          const Divider(height: 32),
          _buildBalanceSection(
            'Compte Beatzcoin',
            beatzcoinBalance,
            beatzcoinAccountId,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(String title, String balance, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          balance,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          id,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
