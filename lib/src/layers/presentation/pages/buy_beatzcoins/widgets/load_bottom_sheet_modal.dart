import 'package:flutter/gestures.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/exchange_fiat_to_bzc_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/get_bzc_currency_converter_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/network/my_http/my_http.dart';
import '../../../../../core/use_cases/use_case.dart';
import '../../../../domain/entities/exchange_bzc_pack_entity.dart';
import '../../../../../core/generated/locale_keys.g.dart';
import '../../../cubits/user_balance_cubit.dart';
import '../../../helpers/ui_alert_helpers.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/squared_bzc_svg_image.dart';

class LoadBottomSheetModal extends StatefulWidget {
  final bool isAfrican;
  final double bzcQuantity;
  final ExchangeBzcPackEntity? bzcExchangePack;

  const LoadBottomSheetModal._(
    this.isAfrican,
    this.bzcQuantity,
    this.bzcExchangePack,
  );

  static Future<void> show(
    BuildContext context, {
    required bool isAfrican,
    required double bzcQuantity,
    ExchangeBzcPackEntity? bzcExchangePack,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LoadBottomSheetModal._(
        isAfrican,
        bzcQuantity,
        bzcExchangePack,
      ),
    );
  }

  @override
  State<LoadBottomSheetModal> createState() => _LoadBottomSheetModalState();
}

class _LoadBottomSheetModalState extends State<LoadBottomSheetModal> {
  final userBalanceCubit = Modular.get<UserBalanceCubit>();

  BzcCurrencyConverter? _bzcCurrencyConverter;

  bool isProcessing = false;

  String get fiatCurrencySymbol => widget.isAfrican ? 'F CFA' : '€';

  bool get initialized =>
      widget.bzcExchangePack != null || _bzcCurrencyConverter != null;

  @override
  void initState() {
    super.initState();
    Modular.get<GetBzcCurrencyConverterUseCase>()
        .call(NoParms())
        .then((converter) => setState(() => _bzcCurrencyConverter = converter));
  }

  double get bzcQuantity {
    return widget.bzcExchangePack?.bzcAmount ?? widget.bzcQuantity;
  }

  double? get fiatAmountInEur {
    final bzcExchangePack = widget.bzcExchangePack;
    return bzcExchangePack != null
        ? bzcExchangePack.fiatAmount
        : _bzcCurrencyConverter?.bzcToEur(widget.bzcQuantity, applyFees: false);
  }

  double? get fiatAmount {
    final amount = fiatAmountInEur;
    if (amount == null) return null;
    return widget.isAfrican ? _bzcCurrencyConverter?.eurToXaf(amount) : amount;
  }

  void onPayWithBantubeat() async {
    final amountInEur = fiatAmountInEur;
    if (amountInEur == null || isProcessing) return;

    try {
      setState(() => isProcessing = true);
      await Modular.get<ExchangeFiatToBzcUseCase>().call(
        (
          fiatAmountInEur: amountInEur,
          exchangeBzcPackId: widget.bzcExchangePack?.id,
        ),
      );

      userBalanceCubit.fetchUserBalance();

      UiAlertHelpers.showSuccessToast(
        LocaleKeys
            .wallet_module_wallets_page_beatzcoin_account_exchange_successful
            .tr(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      final statusCode = (e is MyHttpException) ? e.statusCode : 0;
      var message = (e is MyHttpException) ? e.message : null;

      if (statusCode == 406) {
        message = LocaleKeys.wallet_module_common_insufficient_funds.tr();
      }

      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_common_an_error_occur.tr(
          namedArgs: {'message': message ?? e.toString()},
        ),
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void onPayWithGoogle() {}

  void onPayWithApple() {}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiatAmount = this.fiatAmount;
    double? balance;
    if (userBalanceCubit.state.data != null) {
      balance = widget.isAfrican
          ? userBalanceCubit.state.data?.xaf
          : userBalanceCubit.state.data?.eur;
    }
    bool? isFundsInsufficient;
    if (fiatAmount != null && balance != null) {
      isFundsInsufficient = balance < fiatAmount;
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Visibility(
        visible: initialized,
        replacement: const LinearProgressIndicator(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(height: 4, width: 40, color: Colors.grey[300]),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.wallet_module_buy_beatzcoins_page_modal_title.tr(),
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF151515),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .wallet_module_buy_beatzcoins_page_modal_amount_of_your_load
                        .tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Stack(
                          children: [
                            const SquaredBzcSvgImage(width: 100),
                            Positioned(
                              top: 5,
                              right: 10,
                              child: Text(
                                bzcQuantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          width: double.maxFinite,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF14DF21),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys
                                    .wallet_module_buy_beatzcoins_page_modal_ttc_price
                                    .tr(
                                  namedArgs: {
                                    'price':
                                        '', /*
                                      'price': fiatAmount == null
                                          ? '...'
                                          : NumberFormat.currency(
                                              symbol: fiatCurrencySymbol,
                                            ).format(fiatAmount), */
                                  },
                                ),
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fiatAmount == null
                                    ? '...'
                                    : NumberFormat.currency(
                                        symbol: fiatCurrencySymbol,
                                      ).format(fiatAmount),
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (fiatAmountInEur != fiatAmount)
                                const SizedBox(height: 4),
                              if (fiatAmountInEur != fiatAmount)
                                Text(
                                  NumberFormat.currency(symbol: 'Є').format(
                                    fiatAmountInEur,
                                  ),
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontSize: 13.5,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.wallet_module_buy_beatzcoins_page_modal_buy_with.tr(),
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF151515),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isFundsInsufficient == true
                    ? Colors.grey
                    : const Color(0xFF42A45D),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: BlocBuilder<UserBalanceCubit,
                  AsyncSnapshot<UserBalanceEntity>>(
                bloc: userBalanceCubit,
                builder: (context, balanceSnap) => Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys
                              .wallet_module_buy_beatzcoins_page_modal_bantubeat_balance
                              .tr(),
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              '(ID: ${balanceSnap.data?.financialWalletNumber})',
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
                    Builder(
                      builder: (context) {
                        var text = balanceSnap.hasData
                            ? NumberFormat.currency(
                                symbol: fiatCurrencySymbol,
                              ).format(
                                widget.isAfrican
                                    ? balanceSnap.data?.xaf
                                    : balanceSnap.data?.eur,
                              )
                            : '...';

                        if (isFundsInsufficient == true) {
                          text = LocaleKeys
                              .wallet_module_common_insufficient_funds
                              .tr();
                        }
                        return Text(
                          text,
                          style: TextStyle(
                            fontSize: 20,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isFundsInsufficient == true)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFBAB9B9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys
                          .wallet_module_buy_beatzcoins_page_modal_insufficient_funds
                          .tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFFC0909),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ActionButton(
                      onPressed: Modular.get<WalletRoutes>().deposit.navigate,
                      text: LocaleKeys
                          .wallet_module_buy_beatzcoins_page_modal_add_funds
                          .tr(),
                      backgroundColor: colorScheme.primary,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            if (isFundsInsufficient == false)
              Row(
                children: [
                  Flexible(
                    child: ActionButton(
                      enabled: !isProcessing,
                      onPressed: Navigator.of(context).pop,
                      text: LocaleKeys.wallet_module_common_cancel.tr(),
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Visibility(
                      visible: !isProcessing,
                      replacement: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      child: ActionButton(
                        enabled: !isProcessing,
                        onPressed: onPayWithBantubeat,
                        text: LocaleKeys.wallet_module_common_buy.tr(),
                        backgroundColor: colorScheme.primary,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            /*
            SizedBox(height: 20),
            ActionButton(
              enabled: !isProcessing,
              onPressed: onPayWithApple,
              fullWidth: true,
              prefixIcon: Icon(Icons.apple, color: Colors.black, size: 28),
              text: 'Pay',
              backgroundColor: Colors.white,
              textColor: Colors.black,
            ), 
            SizedBox(height: 20),
            ActionButton(
              enabled: !isProcessing,
              onPressed: onPayWithGoogle,
              fullWidth: true,
              prefixIcon: GoogleIconSvgImage(width: 20),
              text: ' Pay',
              backgroundColor: Colors.white,
              textColor: Colors.black,
            ),
            SizedBox(height: 20),
            Text(
              LocaleKeys.wallet_module_buy_beatzcoins_page_modal_warning1.tr(),
              style: TextStyle(fontSize: 12, color: Color(0xFF181818)),
            ),  */
            const SizedBox(height: 10),
            Center(
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: LocaleKeys
                      .wallet_module_buy_beatzcoins_page_modal_warning2a
                      .tr(),
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF181818)),
                  children: [
                    TextSpan(
                      text: LocaleKeys
                          .wallet_module_buy_beatzcoins_page_modal_warning2b
                          .tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                            Uri.parse(
                              'https://legal.bantubeat.com/bantubeat/help-center?index=12',
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
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
