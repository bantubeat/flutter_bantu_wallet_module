import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_balance_entity.dart';
import '../../../presentation/cubits/user_balance_cubit.dart';
import '../../../presentation/navigation/wallet_routes.dart';

import '../../../../core/generated/locale_keys.g.dart';

class BeatzcoinsPage extends StatelessWidget {
  const BeatzcoinsPage({super.key});

  // clic sur voir détails doit ouvrir la page historique bzc
  void onViewDetails() => Modular.get<WalletRoutes>().transactions.push();

  void onBuyBzc() {
    Modular.get<WalletRoutes>().buyBeatzcoins.push();
  }

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
        title: Text(
          LocaleKeys.wallet_module_featlink_home_page_title.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    TextSpan(
                      text: LocaleKeys.wallet_module_beatzcoins_page_intro1
                          .tr(),
                    ),
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
                  text:
                      LocaleKeys.wallet_module_beatzcoins_page_description.tr(),
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
                                    .wallet_module_beatzcoins_page_bzc_account_balance
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
                                  BeatzcoinAccountEntity?>(
                                bloc: Modular.get<UserBalanceCubit>(),
                                selector: (snap) => snap.data?.beatzcoinAccount,
                                builder: (context, bzcBalance) => RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: bzcBalance == null
                                            ? '...'
                                            : NumberFormat.decimalPattern()
                                                .format(bzcBalance.balance),
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
                            color: colorScheme.primary.withValues(alpha: 0.15),
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
                                LocaleKeys.wallet_module_common_account_id.tr(
                                  namedArgs: {
                                    'id': beatzcoinWalletNumber ?? '...',
                                  },
                                ),
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
                                    ClipboardData(text: beatzcoinWalletNumber),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        LocaleKeys.wallet_module_common_copied
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
                      onTap: onViewDetails,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocaleKeys.wallet_module_beatzcoins_page_see_details
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

              const SizedBox(height: 28),

              // Bouton acheter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onBuyBzc,
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    LocaleKeys.wallet_module_beatzcoins_page_buy_bzc.tr(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../domain/entities/user_balance_entity.dart';
// import '../../../presentation/cubits/user_balance_cubit.dart';
// import '../../../presentation/navigation/wallet_routes.dart';

// import '../../../../core/generated/locale_keys.g.dart';

// import '../../widgets/action_button.dart';

// class BeatzcoinsPage extends StatelessWidget {
//   const BeatzcoinsPage({super.key});

//   // clic sur voir détails doit ouvrir la page historique bzc
//   void onViewDetails() => Modular.get<WalletRoutes>().transactions.push();

//   void onBuyBzc() {
//     Modular.get<WalletRoutes>().buyBeatzcoins.push();
//   }

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
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 40,
//                 width: double.maxFinite,
//                 padding: const EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   color: colorScheme.onSurface,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Text(
//                   'Beatzcoin',
//                   style: TextStyle(
//                     color: colorScheme.onPrimary,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Container(
//                 padding: const EdgeInsets.all(5),
//                 color: colorScheme.primary.withValues(alpha: 0.2),
//                 alignment: Alignment.center,
//                 child: RichText(
//                   textAlign: TextAlign.justify,
//                   text: TextSpan(
//                     text: LocaleKeys.wallet_module_beatzcoins_page_description
//                         .tr(),
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       color: colorScheme.onSurface,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: LocaleKeys
//                             .wallet_module_beatzcoins_page_description2
//                             .tr(),
//                         style: const TextStyle(
//                           fontSize: 14.0,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextSpan(
//                         text: LocaleKeys
//                             .wallet_module_beatzcoins_page_description3
//                             .tr(),
//                         style: TextStyle(
//                           fontSize: 14.0,
//                           color: colorScheme.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             launchUrlString(
//                               'https://legal.bantubeat.com/bantubeat/help-center?index=12',
//                             );
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               /*
//             SizedBox(height: 30.0),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline,
//                       color: Theme.of(context).colorScheme.primary),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Les demandes de paiement sont effectuées via votre profil Bantubeat.',
//                       style: const TextStyle(
//                         color: Color.fromRGBO(18, 18, 18, 1),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ), */
//               const SizedBox(height: 24),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: colorScheme.primary,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           LocaleKeys
//                               .wallet_module_beatzcoins_page_bzc_account_balance
//                               .tr(),
//                           style: TextStyle(
//                             color: colorScheme.onPrimary,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         BlocSelector<UserBalanceCubit,
//                             AsyncSnapshot<UserBalanceEntity>, String?>(
//                           bloc: Modular.get<UserBalanceCubit>(),
//                           selector: (state) =>
//                               state.data?.beatzcoinWalletNumber,
//                           builder: (context, beatzcoinWalletNumber) => Flexible(
//                             child: FittedBox(
//                               child: Text(
//                                 '(ID: $beatzcoinWalletNumber)',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: colorScheme.onPrimary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     BlocSelector<UserBalanceCubit,
//                         AsyncSnapshot<UserBalanceEntity>, double?>(
//                       bloc: Modular.get<UserBalanceCubit>(),
//                       selector: (snap) => snap.data?.bzc,
//                       builder: (context, bzcBalance) => Text(
//                         bzcBalance == null
//                             ? '...'
//                             : NumberFormat.currency(symbol: 'BZC').format(
//                                 bzcBalance,
//                               ),
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: colorScheme.onPrimary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     Text(
//                       DateFormat('dd MM yyyy').format(DateTime.now()),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: colorScheme.onPrimary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: onViewDetails,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFBAB9B9),
//                   minimumSize: const Size.fromHeight(45),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   LocaleKeys.wallet_module_beatzcoins_page_see_details.tr(),
//                   style: const TextStyle(color: Colors.black, fontSize: 14),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ActionButton(
//                 onPressed: onBuyBzc,
//                 fullWidth: true,
//                 text: LocaleKeys.wallet_module_beatzcoins_page_buy_bzc.tr(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
