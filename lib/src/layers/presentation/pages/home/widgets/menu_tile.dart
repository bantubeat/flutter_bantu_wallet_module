import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuTile extends StatelessWidget {
  final IconData? icon;
  final String? customIconLabel;
  final String title;
  final String subtitle;
  final VoidCallback onPress;
  const MenuTile({
    required this.onPress,
    required this.title,
    required this.subtitle,
    this.icon,
    this.customIconLabel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
                border: customIconLabel != null
                    ? Border.all(color: Colors.black87)
                    : null,
              ),
              alignment: Alignment.center,
              child: customIconLabel != null
                  ? Text(
                      customIconLabel!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Icon(icon, size: 22, color: Colors.black87),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class ChipData {
  final String label;
  final Color color;
  ChipData(this.label, this.color);
}

class EarnCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const EarnCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26, color: Colors.black87),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              // height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Formate un montant selon le code devise (ex: XAF, EUR, USD).
/// Exemple: formatCurrency(284027.03, 'XAF') => "284 027 FCFA"
///          formatCurrency(433.24541284403676, 'EUR') => "433,25 €"
String formatCurrency(double amount, String currencyCode) {
  switch (currencyCode.toUpperCase()) {
    case 'XAF':
      // Le FCFA ne s'affiche pas avec des décimales
      final formatter = NumberFormat.currency(
        locale: 'fr_FR',
        symbol: 'FCFA',
        decimalDigits: 0,
      );
      return formatter.format(amount);

    case 'EUR':
      final formatter = NumberFormat.currency(
        locale: 'fr_FR',
        symbol: '€',
        decimalDigits: 2,
      );
      return formatter.format(amount);

    default:
      final formatter = NumberFormat.currency(
        locale: 'fr_FR',
        symbol: currencyCode,
        decimalDigits: 2,
      );
      return formatter.format(amount);
  }
}
