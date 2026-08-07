import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/get_token_prices_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../domain/entities/token_price_entity.dart';
import '../../../domain/entities/user_balance_entity.dart';
import '../../cubits/user_balance_cubit.dart';
import '../../widgets/action_button.dart';
import 'widgets/beatzcoin_package_card.dart';
import 'widgets/load_bottom_sheet_modal.dart';

part 'widgets/custom_amount_bzc_load_form.dart';

class BuyBeatzcoinsPage extends StatelessWidget {
  const BuyBeatzcoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: false,
        leading: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Featlink Wallet',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocSelector<CurrentUserCubit, AsyncSnapshot<UserEntity>,
            UserEntity?>(
          bloc: Modular.get<CurrentUserCubit>(),
          selector: (snap) => snap.data,
          builder: (context, user) {
            final isAfrican = user?.isAfrican ?? false;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Titre principal
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.15,
                      ),
                      children: [
                        const TextSpan(text: 'Beatzcoin est le token de '),
                        TextSpan(
                          text: 'Featlink',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: LocaleKeys.wallet_module_beatzcoins_page_description
                          .tr(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: LocaleKeys
                              .wallet_module_beatzcoins_page_description2
                              .tr(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            height: 1.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: LocaleKeys
                              .wallet_module_beatzcoins_page_description3
                              .tr(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            height: 1.5,
                            color: Colors.black,
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

                  const SizedBox(height: 28),

                  // Carte solde
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys
                                        .wallet_module_buy_beatzcoins_page_my_balance
                                        .tr()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black45,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  BlocSelector<
                                      UserBalanceCubit,
                                      AsyncSnapshot<UserBalanceEntity>,
                                      double?>(
                                    bloc: Modular.get<UserBalanceCubit>(),
                                    selector: (snap) =>
                                        snap.data?.beatzcoinAccount?.balance,
                                    builder: (context, bzcBalance) => RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: bzcBalance == null
                                                ? '...'
                                                : NumberFormat.decimalPattern()
                                                    .format(bzcBalance),
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                              height: 1,
                                            ),
                                          ),
                                          const TextSpan(text: ' '),
                                          const TextSpan(
                                            text: 'BZC',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ID compte + copier
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: BlocSelector<UserBalanceCubit,
                              AsyncSnapshot<UserBalanceEntity>, String?>(
                            bloc: Modular.get<UserBalanceCubit>(),
                            selector: (state) =>
                                state.data?.beatzcoinAccount?.walletNumber,
                            builder: (context, beatzcoinWalletNumber) => Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'ID COMPTE: ${beatzcoinWalletNumber ?? '...'}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (beatzcoinWalletNumber != null) {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: beatzcoinWalletNumber,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            LocaleKeys
                                                .wallet_module_common_copied
                                                .tr(),
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Voir historique
                        InkWell(
                          onTap: () =>
                              Modular.get<WalletRoutes>().transactions.push(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                LocaleKeys
                                    .wallet_module_beatzcoins_page_see_details
                                    .tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Grille des packs BZC (prix dans la zone monétaire de l'utilisateur)
                  FutureBuilder<TokenPriceEntity>(
                    future: Modular.get<GetTokenPricesUseCase>()
                        .call(NoParms()),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 10,
                          width: double.maxFinite,
                          child: LinearProgressIndicator(minHeight: 2),
                        );
                      }

                      if (snap.data == null) return const SizedBox.shrink();

                      final tokenPrice = snap.requireData;

                      return Wrap(
                        spacing: 15,
                        runSpacing: 20,
                        children: [
                          ...tokenPrice.packs.map(
                            (pack) => BeatzcoinPackageCard(
                              amount: pack.tokenCount,
                              price: pack.price,
                              currencySymbol: tokenPrice.symbol,
                              onTap: () => LoadBottomSheetModal.show(
                                context,
                                isAfrican: isAfrican,
                                tokenPrice: tokenPrice,
                                bzcQuantity: pack.tokenCount,
                                bzcExchangePack: pack,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  _CustomAmountBzcLoadForm(isAfrican: isAfrican),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_entity.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/get_exchange_bzc_packs_use_case.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// import '../../../../core/generated/locale_keys.g.dart';
// import '../../../domain/entities/exchange_bzc_pack_entity.dart';
// import '../../../domain/entities/user_balance_entity.dart';
// import '../../../domain/use_cases/bzc_exchange/get_bzc_currency_converter_use_case.dart';
// import '../../cubits/user_balance_cubit.dart';
// import '../../widgets/action_button.dart';
// import 'widgets/beatzcoin_package_card.dart';
// import 'widgets/load_bottom_sheet_modal.dart';

// part 'widgets/custom_amount_bzc_load_form.dart';

// class BuyBeatzcoinsPage extends StatelessWidget {
//   const BuyBeatzcoinsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor: colorScheme.onPrimary,
//       appBar: AppBar(
//         backgroundColor: colorScheme.onPrimary,
//         centerTitle: true,
//         title: Text(
//           LocaleKeys.wallet_module_beatzcoins_page_title.tr(),
//           textAlign: TextAlign.center,
//           softWrap: true,
//           maxLines: 3,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//         actions: const [SizedBox(width: 40)],
//       ),
//       body: SafeArea(
//         child: BlocSelector<CurrentUserCubit, AsyncSnapshot<UserEntity>, bool>(
//           bloc: Modular.get<CurrentUserCubit>(),
//           selector: (snap) => snap.data?.isAfrican ?? false,
//           builder: (context, isAfrican) => SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 40,
//                   width: double.maxFinite,
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     color: colorScheme.onSurface,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     'Beatzcoin',
//                     style: TextStyle(
//                       color: colorScheme.onPrimary,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Container(
//                   padding: const EdgeInsets.all(5),
//                   color: colorScheme.primary.withValues(alpha: 0.2),
//                   alignment: Alignment.center,
//                   child: RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                       text: LocaleKeys.wallet_module_beatzcoins_page_description
//                           .tr(),
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         color: colorScheme.onSurface,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: LocaleKeys
//                               .wallet_module_beatzcoins_page_description2
//                               .tr(),
//                           style: const TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: LocaleKeys
//                               .wallet_module_beatzcoins_page_description3
//                               .tr(),
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: colorScheme.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               launchUrlString(
//                                 'https://legal.bantubeat.com/bantubeat/help-center?index=12',
//                               );
//                             },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   width: double.maxFinite,
//                   decoration: BoxDecoration(
//                     color: colorScheme.primary,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         LocaleKeys.wallet_module_buy_beatzcoins_page_my_balance
//                             .tr(),
//                         style: TextStyle(
//                           color: colorScheme.onPrimary,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       BlocSelector<UserBalanceCubit,
//                           AsyncSnapshot<UserBalanceEntity>, double?>(
//                         bloc: Modular.get<UserBalanceCubit>(),
//                         selector: (snap) => snap.data?.bzc,
//                         builder: (context, bzcBalance) => Text(
//                           bzcBalance == null
//                               ? '...'
//                               : NumberFormat.currency(symbol: 'BZC').format(
//                                   bzcBalance,
//                                 ),
//                           style: TextStyle(
//                             fontSize: 24,
//                             color: colorScheme.onPrimary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 FutureBuilder(
//                   future: Future.wait(
//                     [
//                       Modular.get<GetExchangeBzcPacksUseCase>().call(NoParms()),
//                       Modular.get<GetBzcCurrencyConverterUseCase>().call(
//                         NoParms(),
//                       ),
//                     ],
//                     eagerError: true,
//                   ),
//                   builder: (context, snap) {
//                     if (snap.connectionState == ConnectionState.waiting) {
//                       return const SizedBox(
//                         height: 10,
//                         width: double.maxFinite,
//                         child: LinearProgressIndicator(minHeight: 2),
//                       );
//                     }

//                     if (snap.data == null) return const SizedBox.shrink();

//                     final exchangeBzcPacks =
//                         snap.requireData.first as List<ExchangeBzcPackEntity>;
//                     final converter =
//                         snap.requireData.last as BzcCurrencyConverter;

//                     return Wrap(
//                       spacing: 15,
//                       runSpacing: 20,
//                       children: [
//                         ...exchangeBzcPacks.map(
//                           (bzcExchangePack) => BeatzcoinPackageCard(
//                             amount: bzcExchangePack.bzcAmount,
//                             price: isAfrican
//                                 ? converter.eurToXaf(bzcExchangePack.fiatAmount)
//                                 : bzcExchangePack.fiatAmount,
//                             isAfrican: isAfrican,
//                             onTap: () => LoadBottomSheetModal.show(
//                               bzcQuantity: bzcExchangePack.bzcAmount,
//                               bzcExchangePack: bzcExchangePack,
//                               isAfrican: isAfrican,
//                               context,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 _CustomAmountBzcLoadForm(isAfrican: isAfrican),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
