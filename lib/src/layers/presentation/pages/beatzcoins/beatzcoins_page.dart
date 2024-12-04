import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/generated/locale_keys.g.dart';

import '../../widgets/action_button.dart';
import '../buy_beatzcoins/buy_beatzcoins_page.dart';

class BeatzcoinsPage extends StatelessWidget {
  const BeatzcoinsPage({super.key});

  static const pageRoute = '/beatzcoins';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: colorScheme.onPrimary,
        title: Text(
          LocaleKeys.beatzcoins_page_title.tr(),
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: double.maxFinite,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Beatzcoin',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(5),
              color: Color(0xFFFFCCCC).withOpacity(0.5),
              child: RichText(
                text: TextSpan(
                  text: LocaleKeys.beatzcoins_page_description.tr(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: LocaleKeys.beatzcoins_page_description2.tr(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: LocaleKeys.beatzcoins_page_description3.tr(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*
            SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Les demandes de paiement sont effectuées via votre profil Bantubeat.',
                      style: const TextStyle(
                        color: Color.fromRGBO(18, 18, 18, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ), */
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        LocaleKeys.beatzcoins_page_bzc_account_balance.tr(),
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            '(ID: ${'1AEH1525N524N525I'.toString()})',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(symbol: 'BZC').format(25488),
                    style: TextStyle(
                      fontSize: 20,
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    DateFormat('dd MM yyyy').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFBAB9B9),
                minimumSize: Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                LocaleKeys.beatzcoins_page_see_details.tr(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ActionButton(
              onPressed: () {
                Modular.to.pushNamed(BuyBeatzcoinsPage.pageRoute);
              },
              fullWidth: true,
              text: LocaleKeys.beatzcoins_page_buy_bzc.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
