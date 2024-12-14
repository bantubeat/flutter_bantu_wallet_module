import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/exchange_fiat_to_bzc_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/get_bzc_currency_converter_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/network/my_http/my_http.dart';
import '../../../../../core/use_cases/use_case.dart';
import '../../../../domain/entities/exchange_bzc_pack_entity.dart';
import '../../../../../core/generated/locale_keys.g.dart';
import '../../../cubits/user_balance_cubit.dart';
import '../../../helpers/ui_alert_helpers.dart';
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
      shape: RoundedRectangleBorder(
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

  double? get fiatAmount {
    final bzcExchangePack = widget.bzcExchangePack;
    if (bzcExchangePack != null) {
      return widget.isAfrican
          ? _bzcCurrencyConverter?.eurToXaf(bzcExchangePack.fiatAmount)
          : bzcExchangePack.fiatAmount;
    }

    return widget.isAfrican
        ? _bzcCurrencyConverter?.bzcToXaf(widget.bzcQuantity)
        : _bzcCurrencyConverter?.bzcToEur(widget.bzcQuantity);
  }

  void onPayWithBantubeat() async {
    try {
      setState(() => isProcessing = true);
      await Modular.get<ExchangeFiatToBzcUseCase>().call(
        (
          bzcQuantity: bzcQuantity,
          exchangeBzcPackId: widget.bzcExchangePack?.id
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
          args: [message ?? e.toString()],
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

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Visibility(
        visible: initialized,
        replacement: LinearProgressIndicator(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(height: 4, width: 40, color: Colors.grey[300]),
            ),
            SizedBox(height: 20),
            Text(
              LocaleKeys.wallet_module_buy_beatzcoins_page_modal_title.tr(),
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF151515),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
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
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Stack(
                          children: [
                            SquaredBzcSvgImage(width: 100),
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
                      SizedBox(width: 10),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          width: double.maxFinite,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF14DF21),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              LocaleKeys
                                  .wallet_module_buy_beatzcoins_page_modal_ttc_price
                                  .tr(
                                args: [
                                  fiatAmount == null
                                      ? '...'
                                      : NumberFormat.currency(
                                          symbol: fiatCurrencySymbol,
                                        ).format(fiatAmount ?? 0),
                                ],
                              ),
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              LocaleKeys.wallet_module_buy_beatzcoins_page_modal_buy_with.tr(),
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF151515),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: isProcessing ? null : onPayWithBantubeat,
              enableFeedback: !isProcessing,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isProcessing ? Colors.grey : colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Visibility(
                  visible: !isProcessing,
                  replacement: Center(
                    child: CircularProgressIndicator.adaptive(),
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
                            /*
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  '', // TODO: '(ID: ${'1AEH1525N524N525I'.toString()})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ), */
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          balanceSnap.hasData
                              ? NumberFormat.currency(
                                  symbol: fiatCurrencySymbol,
                                ).format(
                                  widget.isAfrican
                                      ? balanceSnap.data?.xaf
                                      : balanceSnap.data?.eur,
                                )
                              : '...',
                          style: TextStyle(
                            fontSize: 20,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
            ), */
            SizedBox(height: 20),
            Text(
              LocaleKeys.wallet_module_buy_beatzcoins_page_modal_warning1.tr(),
              style: TextStyle(fontSize: 12, color: Color(0xFF181818)),
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: LocaleKeys
                    .wallet_module_buy_beatzcoins_page_modal_warning2a
                    .tr(),
                style: TextStyle(fontSize: 12, color: Color(0xFF181818)),
                children: [
                  TextSpan(
                    text: LocaleKeys
                        .wallet_module_buy_beatzcoins_page_modal_warning2b
                        .tr(),
                    style: TextStyle(fontSize: 12, color: colorScheme.primary),
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
