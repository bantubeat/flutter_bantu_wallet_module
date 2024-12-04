import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/generated/locale_keys.g.dart';

class PaymentZoneSwitch extends StatelessWidget {
  final bool isAfricanZone;
  final VoidCallback onAfricanZoneTap;
  final VoidCallback onOtherZoneTap;

  const PaymentZoneSwitch({
    required this.isAfricanZone,
    required this.onAfricanZoneTap,
    required this.onOtherZoneTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 80.0),
            blurRadius: 40,
            color: Colors.grey.shade50,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPaymentTab(
              label: LocaleKeys.deposit_page_payment_zone_africa.tr(),
              icon: Icons.phone_android,
              isSelected: isAfricanZone,
              onTap: onAfricanZoneTap,
            ),
          ),
          const SizedBox(width: 10),
          _buildPaymentTab(
            label: LocaleKeys.deposit_page_payment_zone_other.tr(),
            icon: Icons.account_balance,
            isSelected: !isAfricanZone,
            onTap: onOtherZoneTap,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTab({
    required String label,
    required IconData icon,
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
            Icon(
              icon,
              size: 30,
              color: isSelected ? Colors.black : Colors.grey,
            ),
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
