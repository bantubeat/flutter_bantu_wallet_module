import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/get_exchange_bzc_packs_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../domain/entities/exchange_bzc_pack_entity.dart';
import '../../../domain/entities/user_balance_entity.dart';
import '../../../domain/use_cases/get_bzc_currency_converter_use_case.dart';
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        actions: [SizedBox(width: 40)],
      ),
      body: SafeArea(
        child: BlocSelector<CurrentUserCubit, AsyncSnapshot<UserEntity>, bool>(
          bloc: Modular.get<CurrentUserCubit>(),
          selector: (snap) => snap.data?.isAfrican ?? false,
          builder: (context, isAfrican) => SingleChildScrollView(
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
                  color: Color(0xFFFFCCCC).withValues(alpha: 0.5),
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
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
                          style: TextStyle(
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
                        LocaleKeys.wallet_module_buy_beatzcoins_page_my_balance
                            .tr(),
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                        ),
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
                            fontSize: 24,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                FutureBuilder(
                  future: Future.wait(
                    [
                      Modular.get<GetExchangeBzcPacksUseCase>().call(NoParms()),
                      Modular.get<GetBzcCurrencyConverterUseCase>().call(
                        NoParms(),
                      ),
                    ],
                    eagerError: true,
                  ),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 10,
                        width: double.maxFinite,
                        child: LinearProgressIndicator(minHeight: 2),
                      );
                    }

                    if (snap.data == null) return const SizedBox.shrink();

                    final exchangeBzcPacks =
                        snap.requireData.first as List<ExchangeBzcPackEntity>;
                    final converter =
                        snap.requireData.last as BzcCurrencyConverter;

                    return Wrap(
                      spacing: 15,
                      runSpacing: 20,
                      children: [
                        ...exchangeBzcPacks.map(
                          (bzcExchangePack) => BeatzcoinPackageCard(
                            amount: bzcExchangePack.bzcAmount,
                            price: isAfrican
                                ? converter.eurToXaf(bzcExchangePack.fiatAmount)
                                : bzcExchangePack.fiatAmount,
                            isAfrican: isAfrican,
                            onTap: () => LoadBottomSheetModal.show(
                              bzcQuantity: bzcExchangePack.bzcAmount,
                              bzcExchangePack: bzcExchangePack,
                              isAfrican: isAfrican,
                              context,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                _CustomAmountBzcLoadForm(isAfrican: isAfrican),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
