import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widgets/squared_bzc_svg_image.dart';

class BeatzcoinPackageCard extends StatelessWidget {
  final double amount;
  final double price;
  final bool isAfrican;
  final VoidCallback onTap;

  const BeatzcoinPackageCard({
    required this.amount,
    required this.price,
    required this.isAfrican,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final maxW = screenSize.width / 2 - 25;
    return Container(
      padding: EdgeInsets.zero,
      width: maxW,
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: kElevationToShadow[1],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              children: [
                SquaredBzcSvgImage(width: maxW),
                Positioned(
                  top: 15,
                  right: 20,
                  child: Text(
                    amount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              width: double.maxFinite,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF14DF21),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: NumberFormat.currency(symbol: ' ', locale: 'EU')
                            .format(price)
                            .replaceAll('.', ' ')
                            .replaceFirst(',00', ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: isAfrican ? 'F CFA ' : '€',
                        style: const TextStyle(
                          color: Colors.limeAccent,
                          //fontWeight: FontWeight.w300,
                          overflow: TextOverflow.visible,
                          fontSize: 16,
                        ),
                      ),
                    ],
                    style: const TextStyle(
                      overflow: TextOverflow.visible,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
