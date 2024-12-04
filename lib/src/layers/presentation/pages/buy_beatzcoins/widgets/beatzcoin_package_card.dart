import 'package:flutter/material.dart';

import '../../../widgets/squared_bzc_svg_image.dart';

class BeatzcoinPackageCard extends StatelessWidget {
  final int amount;
  final double price;

  const BeatzcoinPackageCard({
    required this.amount,
    required this.price,
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
              color: Color(0xFF14DF21),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              '€${price.toStringAsFixed(2)}',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
