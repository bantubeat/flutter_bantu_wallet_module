import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/legal_links.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/withdrawal_description.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApiKeys extends WalletApiKeys {
  const _FakeApiKeys() : super(isProduction: false);

  @override
  String getFlutterwavePublicKey() => '';

  @override
  String getPaypalClientID() => '';

  @override
  String getStripePublishableKey() => '';
}

void main() {
  test('WalletModule keeps the legal URL builder of the host app', () {
    String builder(WalletLegalDoc doc, Locale locale) =>
        'https://example.com/${locale.languageCode}/${doc.name}';

    final module = WalletModule(
      onCloseModule: () {},
      floatingMenuBuilder: () => const SizedBox(),
      getAccessToken: () async => null,
      walletApiKeys: const _FakeApiKeys(),
      onGoToKycForm: null,
      routes: const WalletRoutes('/wallet/'),
      legalUrlBuilder: builder,
    );

    expect(
      module.legalUrlBuilder!(WalletLegalDoc.payment, const Locale('fr')),
      'https://example.com/fr/payment',
    );
  });

  testWidgets('legal links are hidden when no builder is provided',
      (tester) async {
    expect(LegalLinks.isAvailable, isFalse);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WithdrawalDescription())),
    );

    expect(
      find.textContaining(
        LocaleKeys.wallet_module_withdrawal_page_description2,
        findRichText: true,
      ),
      findsOneWidget,
    );
    // The whole sentence holding the link is hidden, not only the link.
    for (final key in [
      LocaleKeys.wallet_module_withdrawal_page_description2_link_intro,
      LocaleKeys.wallet_module_withdrawal_page_description3,
    ]) {
      expect(find.textContaining(key, findRichText: true), findsNothing);
    }
  });
}
