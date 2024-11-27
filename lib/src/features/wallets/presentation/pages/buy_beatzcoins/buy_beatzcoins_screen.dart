
import 'package:flutter/material.dart';

import 'widgets/beatzcoin_package_card.dart';

class BuyBeatzcoinsScreen extends StatelessWidget {
  const BuyBeatzcoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acheter des beatzcoins'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Le Beatzcoin est un jeton que nous mettons sur pied pour permettre aux utilisateurs de profiter pleinement des applications bantubeat.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Voir les conditions d'achat et d'utilisation des Beatzcoins",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Mon solde',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '25.498 BZC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Voir les détails',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  BeatzcoinPackageCard(amount: 50, price: 0.25),
                  BeatzcoinPackageCard(amount: 510, price: 2.50),
                  BeatzcoinPackageCard(amount: 1550, price: 7.50),
                  BeatzcoinPackageCard(amount: 2550, price: 12.50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
