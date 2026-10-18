import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/config/wallet_legal_doc.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/legal_links.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

class WithdrawalDescription extends StatelessWidget {
  const WithdrawalDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Text(
              LocaleKeys.wallet_module_withdrawal_page_description1.tr(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14.0,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 15),
            Text.rich(
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14.0,
                color: colorScheme.onSurface,
              ),
              TextSpan(
                children: [
                  TextSpan(
                    text: LocaleKeys.wallet_module_withdrawal_page_description2
                        .tr(),
                  ),
                  if (LegalLinks.isAvailable)
                    LegalLinks.span(
                      context,
                      WalletLegalDoc.payment,
                      text: LocaleKeys
                          .wallet_module_withdrawal_page_description3
                          .tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
