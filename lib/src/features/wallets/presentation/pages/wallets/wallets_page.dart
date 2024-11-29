import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/generated/locale_keys.g.dart';
import '../../widgets/my_header_bar.dart';
import '../../widgets/my_small_button.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  static const pageRoute = '/wallets';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyHeaderBar(title: LocaleKeys.wallets_page_title.tr()),
            const SizedBox(height: 7.5),
            Container(
              padding: const EdgeInsets.all(5),
              color: Color(0xFFFFCCCC).withOpacity(0.5),
              child: RichText(
                text: TextSpan(
                  text: LocaleKeys.wallets_page_description.tr(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: LocaleKeys.wallets_page_description2.tr(),
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
            SizedBox(height: 30.0),
            _buildFinancierAccount(context),
            SizedBox(height: 16.0),
            _buildBeatzacoinAccount(context),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancierAccount(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(5),
      color: Color(0xFFEBEBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.wallets_page_financier_account_title.tr(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          'ID: 2481525265265525',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              MySmallButton(
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                useFittedBox: true,
                text: NumberFormat.currency(symbol: '€').format(1952),
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            LocaleKeys.wallets_page_financier_account_description.tr(),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MySmallButton(
                backgroundColor: colorScheme.onSurface,
                textColor: colorScheme.onPrimary,
                useFittedBox: true,
                text: LocaleKeys.wallets_page_financier_account_request_payment
                    .tr(),
                onTap: () {},
              ),
              MySmallButton(
                backgroundColor: colorScheme.onSurface.withAlpha(200),
                textColor: colorScheme.onPrimary,
                useFittedBox: true,
                text: LocaleKeys.wallets_page_financier_account_add_funds.tr(),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeatzacoinAccount(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(5),
      color: Color(0xFFEBEBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.wallets_page_beatzocoin_account_title.tr(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          'ID: 2481525265265525',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              MySmallButton(
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                useFittedBox: true,
                text: NumberFormat.currency(symbol: 'BZC').format(1000),
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            LocaleKeys.wallets_page_beatzocoin_account_description1.tr(),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10),
          Text(
            LocaleKeys.wallets_page_beatzocoin_account_description2.tr(),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text:
                  LocaleKeys.wallets_page_beatzocoin_account_description3.tr(),
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: LocaleKeys.wallets_page_beatzocoin_account_description4
                      .tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: '0',
                        errorText: LocaleKeys
                            .wallets_page_beatzocoin_account_minimum_bzc
                            .tr(
                          args: ['500'],
                        ),
                        fillColor: Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: EdgeInsets.all(5),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: '0 €',
                        errorText: '',
                        fillColor: Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: EdgeInsets.all(5),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                LocaleKeys.wallets_page_beatzocoin_account_exchange.tr(),
                style: TextStyle(
                  fontSize: 14.0,
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
