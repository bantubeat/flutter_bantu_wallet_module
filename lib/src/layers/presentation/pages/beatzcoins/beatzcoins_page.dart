import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_balance_entity.dart';
import '../../../presentation/cubits/user_balance_cubit.dart';
import '../../../presentation/navigation/wallet_routes.dart';

import '../../../../core/generated/locale_keys.g.dart';

import '../../widgets/action_button.dart';

class BeatzcoinsPage extends StatelessWidget {
  const BeatzcoinsPage({super.key});

  // clic sur voir détails doit ouvrir la page historique bzc
  void onViewDetails() => Modular.get<WalletRoutes>().transactions.push();

  void onBuyBzc() {
    Modular.get<WalletRoutes>().buyBeatzcoins.push();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          LocaleKeys.wallet_module_beatzcoins_page_title.tr(),
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        actions: const [SizedBox(width: 40)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: LocaleKeys.wallet_module_beatzcoins_page_description
                        .tr(),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: LocaleKeys
                            .wallet_module_beatzcoins_page_description2
                            .tr(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: LocaleKeys
                            .wallet_module_beatzcoins_page_description3
                            .tr(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                              'https://legal.bantubeat.com/bantubeat/help-center?index=12',
                            );
                          },
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
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                          LocaleKeys
                              .wallet_module_beatzcoins_page_bzc_account_balance
                              .tr(),
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        BlocSelector<UserBalanceCubit,
                            AsyncSnapshot<UserBalanceEntity>, String?>(
                          bloc: Modular.get<UserBalanceCubit>(),
                          selector: (state) =>
                              state.data?.beatzcoinWalletNumber,
                          builder: (context, beatzcoinWalletNumber) => Flexible(
                            child: FittedBox(
                              child: Text(
                                '(ID: $beatzcoinWalletNumber)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BlocSelector<UserBalanceCubit,
                        AsyncSnapshot<UserBalanceEntity>, double?>(
                      bloc: Modular.get<UserBalanceCubit>(),
                      selector: (snap) => snap.data?.bzc,
                      builder: (context, bzcBalance) => Text(
                        bzcBalance == null
                            ? '...'
                            : NumberFormat.currency(symbol: 'BZC').format(
                                bzcBalance,
                              ),
                        style: TextStyle(
                          fontSize: 20,
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
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
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBAB9B9),
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleKeys.wallet_module_beatzcoins_page_see_details.tr(),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),
              ActionButton(
                onPressed: onBuyBzc,
                fullWidth: true,
                text: LocaleKeys.wallet_module_beatzcoins_page_buy_bzc.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
