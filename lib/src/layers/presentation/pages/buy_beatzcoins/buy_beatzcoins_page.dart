import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../widgets/action_button.dart';
import 'widgets/beatzcoin_package_card.dart';
import 'widgets/load_bottom_sheet_modal.dart';

class BuyBeatzcoinsPage extends StatelessWidget {
  const BuyBeatzcoinsPage({super.key});

  static const pageRoute = '/buy_beatzcoins';

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
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    LocaleKeys.buy_beatzcoins_page_my_balance.tr(),
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(symbol: 'BZC').format(25488),
                    style: TextStyle(
                      fontSize: 24,
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 15,
              runSpacing: 20,
              children: [
                BeatzcoinPackageCard(amount: 50, price: 0.25),
                BeatzcoinPackageCard(amount: 510, price: 2.50),
                BeatzcoinPackageCard(amount: 1550, price: 7.50),
                BeatzcoinPackageCard(amount: 2550, price: 12.50),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                border: Border.all(width: 1, color: Colors.grey.shade300),
                boxShadow: kElevationToShadow[1],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.buy_beatzcoins_page_custom_load.tr(),
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            LocaleKeys.buy_beatzcoins_page_enter_quantity.tr(),
                        filled: true,
                        fillColor: Color(0xFFEBEBEB),
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFA5A5A5),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.buy_beatzcoins_page_ttc_amount_in
                              .tr(args: ['€']),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '0.00',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ActionButton(
                      onPressed: () => LoadBottomSheetModal.show(context),
                      fullWidth: true,
                      text: LocaleKeys.buy_beatzcoins_page_load.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
