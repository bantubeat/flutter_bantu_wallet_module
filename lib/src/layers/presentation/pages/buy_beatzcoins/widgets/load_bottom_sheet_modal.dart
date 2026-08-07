import 'package:flutter/gestures.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/purchase_token_pack_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/get_bzc_currency_converter_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/network/my_http/my_http.dart';
import '../../../../../core/use_cases/use_case.dart';
import '../../../../domain/entities/token_price_entity.dart';
import '../../../../domain/entities/exchange_transaction_entity.dart';
import '../../../../../core/generated/locale_keys.g.dart';
import '../../../cubits/user_balance_cubit.dart';
import '../../../helpers/ui_alert_helpers.dart';
import '../../../helpers/pdf_printer.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/squared_bzc_svg_image.dart';
import '../payment_success_page.dart';

class LoadBottomSheetModal extends StatefulWidget {
  final bool isAfrican;
  final TokenPriceEntity tokenPrice;
  final double bzcQuantity;
  final TokenPackEntity? bzcExchangePack;

  const LoadBottomSheetModal._(
    this.isAfrican,
    this.tokenPrice,
    this.bzcQuantity,
    this.bzcExchangePack,
  );

  static Future<void> show(
    BuildContext context, {
    required bool isAfrican,
    required TokenPriceEntity tokenPrice,
    required double bzcQuantity,
    TokenPackEntity? bzcExchangePack,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => LoadBottomSheetModal._(
        isAfrican,
        tokenPrice,
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

  String get fiatCurrencySymbol => widget.tokenPrice.symbol;

  bool get initialized => true;

  @override
  void initState() {
    super.initState();
    Modular.get<GetBzcCurrencyConverterUseCase>()
        .call(NoParms())
        .then((converter) => setState(() => _bzcCurrencyConverter = converter));
  }

  double get bzcQuantity {
    return widget.bzcExchangePack?.tokenCount ?? widget.bzcQuantity;
  }

  double? get fiatAmount {
    final pack = widget.bzcExchangePack;
    if (pack != null) return pack.price;
    return widget.bzcQuantity * widget.tokenPrice.unitPrice;
  }

  /// Montant réellement payé, dans la devise de l'utilisateur.
  /// Le backend renvoie `local_amount` (XAF/FCFA) ; on retombe sur la
  /// conversion EUR→XAF si absent.
  double _successMontant(ExchangeTransactionEntity res) {
    if (!widget.isAfrican) return res.fiatAmount;
    return res.localAmount ??
        _bzcCurrencyConverter?.eurToXaf(res.fiatAmount) ??
        res.fiatAmount;
  }

  /// Devise affichée sur l'écran de succès
  String _successCurrency(ExchangeTransactionEntity res) {
    if (!widget.isAfrican) return '€';
    return res.localCurrencySymbol ?? widget.tokenPrice.symbol;
  }

  /// Montant de la TVA dans la devise affichée (XAF côté africain, EUR sinon)
  double _tvaAmount(ExchangeTransactionEntity res) {
    if (widget.isAfrican) return res.tvaAmount;
    return _bzcCurrencyConverter?.xafToEur(res.tvaAmount) ?? res.tvaAmount;
  }

  void onPayWithBantubeat() async {
    final bzcQuantity = this.bzcQuantity;
    if (isProcessing) return;

    try {
      setState(() => isProcessing = true);
      final res = await Modular.get<PurchaseTokenPackUseCase>()
          .call((tokenCount: bzcQuantity));
      debugPrint(res.toString());
      userBalanceCubit.fetchUserBalance();

      UiAlertHelpers.showSuccessToast(
        LocaleKeys
            .wallet_module_wallets_page_beatzcoin_account_exchange_successful
            .tr(),
      );
      if (mounted) {
        final successMontant = _successMontant(res);
        final successCurrency = _successCurrency(res);
        final transactionId = res.transactionNumber ?? 'FTA-${res.id}';
        final tvaAmount = _tvaAmount(res);
        final paymentMethod = LocaleKeys
            .wallet_module_buy_beatzcoins_page_modal_bantubeat_balance
            .tr();
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => PaymentSuccessPage(
              montant: successMontant,
              currency: successCurrency,
              jetons: res.bzcAmount,
              transactionId: transactionId,
              paymentMethod: paymentMethod,
              date: res.createdAt,
              service: 'Beatzcoin',
              frais: res.fees,
              tvaRate: res.tvaRate,
              tvaAmount: tvaAmount,
              onDownloadReceipt: () async {
                try {
                  final currencyFormat = NumberFormat.decimalPattern('fr');
                  final details = <String, String>{
                    LocaleKeys.wallet_module_common_service.tr(): 'Beatzcoin',
                    LocaleKeys
                        .wallet_module_transaction_history_page_table_transaction_id
                        .tr(): transactionId,
                    LocaleKeys.wallet_module_common_payment_method.tr():
                        paymentMethod,
                    LocaleKeys.wallet_module_transaction_history_page_table_date
                            .tr():
                        DateFormat('dd/MM/yyyy HH:mm').format(res.createdAt),
                    LocaleKeys.wallet_module_common_amount.tr():
                        '${currencyFormat.format(successMontant)} $successCurrency',
                    LocaleKeys.wallet_module_common_tokens.tr():
                        '${currencyFormat.format(res.bzcAmount)} BZC',
                    LocaleKeys.wallet_module_common_fees.tr():
                        '${currencyFormat.format(res.fees)} $successCurrency',
                    LocaleKeys.wallet_module_payment_success_page_vat_rate.tr(
                      namedArgs: {
                        'rate':
                            res.tvaRate.toStringAsFixed(2).replaceAll('.', ','),
                      },
                    ): '${currencyFormat.format(tvaAmount)} $successCurrency',
                  };
                  await printDetailsPdf(
                    title: LocaleKeys
                        .wallet_module_transaction_history_page_table_caption
                        .tr(),
                    details: details,
                  );
                } catch (e) {
                  if (!c.mounted) return;
                  UiAlertHelpers.showErrorToast(
                    LocaleKeys.wallet_module_common_an_error_occur.tr(
                      namedArgs: {'message': e.toString()},
                    ),
                  );
                }
              },
              onClose: () {
                if (mounted) {
                  Navigator.of(context).maybePop();
                }
              },
            ),
          ),
        );
        if (mounted) {
          Navigator.of(context).maybePop();
        }
      }
      return;
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Visibility(
          visible: initialized,
          replacement: const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: LinearProgressIndicator(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poignée
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // En-tête : titre + fermer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.wallet_module_buy_beatzcoins_page_modal_title
                        .tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF151515),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Carte montant BZC / prix
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const SquaredBzcSvgImage(width: 70),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              bzcQuantity.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${bzcQuantity.toStringAsFixed(0)} BZC',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        fiatAmount == null
                            ? '...'
                            : NumberFormat.currency(
                                symbol: fiatCurrencySymbol,
                                decimalDigits: 0,
                              ).format(fiatAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bannière solde insuffisant (logique inchangée)
              if (isFundsInsufficient == true)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEAEA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Color(0xFFD32F2F),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Solde insuffisant',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              LocaleKeys
                                  .wallet_module_buy_beatzcoins_page_modal_insufficient_funds
                                  .tr(),
                              style: const TextStyle(
                                color: Color(0xFFB23B3B),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              Text(
                'MODE DE PAIEMENT'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black45,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 10),

              // Carte solde compte (logique inchangée)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEFEFEF)),
                ),
                child: BlocBuilder<UserBalanceCubit,
                    AsyncSnapshot<UserBalanceEntity>>(
                  bloc: userBalanceCubit,
                  builder: (context, balanceSnap) => Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys
                                  .wallet_module_buy_beatzcoins_page_modal_bantubeat_balance
                                  .tr(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ID : ${balanceSnap.data?.paymentAccount?.walletNumber ?? '...'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                final text = balanceSnap.hasData
                                    ? NumberFormat.currency(
                                        symbol: fiatCurrencySymbol,
                                        decimalDigits: 2,
                                      ).format(
                                        widget.isAfrican
                                            ? balanceSnap.data?.xaf
                                            : balanceSnap.data?.eur,
                                      )
                                    : '...';
                                return Text(
                                  text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (isFundsInsufficient == false)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF2ECC71),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Boutons d'action (logique inchangée)
              if (isFundsInsufficient == true)
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    onPressed: Modular.get<WalletRoutes>().deposit.push,
                    fullWidth: true,
                    text:
                        '${LocaleKeys.wallet_module_buy_beatzcoins_page_modal_add_funds.tr()}  →',
                    backgroundColor: const Color(0xFF1A1A1A),
                    textColor: Colors.white,
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
                        backgroundColor: const Color(0xFFF2F2F2),
                        textColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Visibility(
                        visible: !isProcessing,
                        replacement: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        child: ActionButton(
                          enabled: !isProcessing,
                          onPressed: onPayWithBantubeat,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 16,
                          ),
                          text: LocaleKeys.wallet_module_common_buy.tr(),
                          backgroundColor: const Color(0xFF1A1A1A),
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 14),

              // Mentions légales (logique inchangée)
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: LocaleKeys
                        .wallet_module_buy_beatzcoins_page_modal_warning2a
                        .tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF181818),
                    ),
                    children: [
                      TextSpan(
                        text: LocaleKeys
                            .wallet_module_buy_beatzcoins_page_modal_warning2b
                            .tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          // color: colorScheme.primary,
                          decoration: TextDecoration.underline,
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
      ),
    );
  }
}

// import 'package:flutter/gestures.dart';
// import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/exchange_fiat_to_bzc_use_case.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/bzc_exchange/get_bzc_currency_converter_use_case.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../../../core/network/my_http/my_http.dart';
// import '../../../../../core/use_cases/use_case.dart';
// import '../../../../domain/entities/exchange_bzc_pack_entity.dart';
// import '../../../../../core/generated/locale_keys.g.dart';
// import '../../../cubits/user_balance_cubit.dart';
// import '../../../helpers/ui_alert_helpers.dart';
// import '../../../widgets/action_button.dart';
// import '../../../widgets/squared_bzc_svg_image.dart';

// class LoadBottomSheetModal extends StatefulWidget {
//   final bool isAfrican;
//   final double bzcQuantity;
//   final ExchangeBzcPackEntity? bzcExchangePack;

//   const LoadBottomSheetModal._(
//     this.isAfrican,
//     this.bzcQuantity,
//     this.bzcExchangePack,
//   );

//   static Future<void> show(
//     BuildContext context, {
//     required bool isAfrican,
//     required double bzcQuantity,
//     ExchangeBzcPackEntity? bzcExchangePack,
//   }) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => LoadBottomSheetModal._(
//         isAfrican,
//         bzcQuantity,
//         bzcExchangePack,
//       ),
//     );
//   }

//   @override
//   State<LoadBottomSheetModal> createState() => _LoadBottomSheetModalState();
// }

// class _LoadBottomSheetModalState extends State<LoadBottomSheetModal> {
//   final userBalanceCubit = Modular.get<UserBalanceCubit>();

//   BzcCurrencyConverter? _bzcCurrencyConverter;

//   bool isProcessing = false;

//   String get fiatCurrencySymbol => widget.isAfrican ? 'F CFA' : '€';

//   bool get initialized =>
//       widget.bzcExchangePack != null || _bzcCurrencyConverter != null;

//   @override
//   void initState() {
//     super.initState();
//     Modular.get<GetBzcCurrencyConverterUseCase>()
//         .call(NoParms())
//         .then((converter) => setState(() => _bzcCurrencyConverter = converter));
//   }

//   double get bzcQuantity {
//     return widget.bzcExchangePack?.bzcAmount ?? widget.bzcQuantity;
//   }

//   double? get fiatAmountInEur {
//     final bzcExchangePack = widget.bzcExchangePack;
//     return bzcExchangePack != null
//         ? bzcExchangePack.fiatAmount
//         : _bzcCurrencyConverter?.bzcToEur(widget.bzcQuantity, applyFees: false);
//   }

//   double? get fiatAmount {
//     final amount = fiatAmountInEur;
//     if (amount == null) return null;
//     return widget.isAfrican ? _bzcCurrencyConverter?.eurToXaf(amount) : amount;
//   }

//   void onPayWithBantubeat() async {
//     final amountInEur = fiatAmountInEur;
//     if (amountInEur == null || isProcessing) return;

//     try {
//       setState(() => isProcessing = true);
//       await Modular.get<ExchangeFiatToBzcUseCase>().call(
//         (
//           fiatAmountInEur: amountInEur,
//           exchangeBzcPackId: widget.bzcExchangePack?.id,
//         ),
//       );

//       userBalanceCubit.fetchUserBalance();

//       UiAlertHelpers.showSuccessToast(
//         LocaleKeys
//             .wallet_module_wallets_page_beatzcoin_account_exchange_successful
//             .tr(),
//       );
//       if (mounted) Navigator.of(context).pop();
//     } catch (e) {
//       final statusCode = (e is MyHttpException) ? e.statusCode : 0;
//       var message = (e is MyHttpException) ? e.message : null;

//       if (statusCode == 406) {
//         message = LocaleKeys.wallet_module_common_insufficient_funds.tr();
//       }

//       UiAlertHelpers.showErrorToast(
//         LocaleKeys.wallet_module_common_an_error_occur.tr(
//           namedArgs: {'message': message ?? e.toString()},
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => isProcessing = false);
//     }
//   }

//   void onPayWithGoogle() {}

//   void onPayWithApple() {}

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final fiatAmount = this.fiatAmount;
//     double? balance;
//     if (userBalanceCubit.state.data != null) {
//       balance = widget.isAfrican
//           ? userBalanceCubit.state.data?.xaf
//           : userBalanceCubit.state.data?.eur;
//     }
//     bool? isFundsInsufficient;
//     if (fiatAmount != null && balance != null) {
//       isFundsInsufficient = balance < fiatAmount;
//     }
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9F9F9),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Visibility(
//         visible: initialized,
//         replacement: const LinearProgressIndicator(),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(height: 4, width: 40, color: Colors.grey[300]),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               LocaleKeys.wallet_module_buy_beatzcoins_page_modal_title.tr(),
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF151515),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     LocaleKeys
//                         .wallet_module_buy_beatzcoins_page_modal_amount_of_your_load
//                         .tr(),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: Stack(
//                           children: [
//                             const SquaredBzcSvgImage(width: 100),
//                             Positioned(
//                               top: 5,
//                               right: 10,
//                               child: Text(
//                                 bzcQuantity.toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Flexible(
//                         child: Container(
//                           margin: const EdgeInsets.all(10),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 4,
//                           ),
//                           width: double.maxFinite,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF14DF21),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           alignment: Alignment.center,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 LocaleKeys
//                                     .wallet_module_buy_beatzcoins_page_modal_ttc_price
//                                     .tr(
//                                   namedArgs: {
//                                     'price':
//                                         '', /*
//                                       'price': fiatAmount == null
//                                           ? '...'
//                                           : NumberFormat.currency(
//                                               symbol: fiatCurrencySymbol,
//                                             ).format(fiatAmount), */
//                                   },
//                                 ),
//                                 style: TextStyle(
//                                   color: colorScheme.onPrimary,
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.underline,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 fiatAmount == null
//                                     ? '...'
//                                     : NumberFormat.currency(
//                                         symbol: fiatCurrencySymbol,
//                                       ).format(fiatAmount),
//                                 style: TextStyle(
//                                   color: colorScheme.onPrimary,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               if (fiatAmountInEur != fiatAmount)
//                                 const SizedBox(height: 4),
//                               if (fiatAmountInEur != fiatAmount)
//                                 Text(
//                                   NumberFormat.currency(symbol: 'Є').format(
//                                     fiatAmountInEur,
//                                   ),
//                                   style: TextStyle(
//                                     color: colorScheme.onPrimary,
//                                     fontSize: 13.5,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               LocaleKeys.wallet_module_buy_beatzcoins_page_modal_buy_with.tr(),
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFF151515),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: isFundsInsufficient == true
//                     ? Colors.grey
//                     : const Color(0xFF42A45D),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: BlocBuilder<UserBalanceCubit,
//                   AsyncSnapshot<UserBalanceEntity>>(
//                 bloc: userBalanceCubit,
//                 builder: (context, balanceSnap) => Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           LocaleKeys
//                               .wallet_module_buy_beatzcoins_page_modal_bantubeat_balance
//                               .tr(),
//                           style: TextStyle(
//                             color: colorScheme.onPrimary,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Flexible(
//                           child: FittedBox(
//                             child: Text(
//                               '(ID: ${balanceSnap.data?.financialWalletNumber})',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: colorScheme.onPrimary,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Builder(
//                       builder: (context) {
//                         var text = balanceSnap.hasData
//                             ? NumberFormat.currency(
//                                 symbol: fiatCurrencySymbol,
//                               ).format(
//                                 widget.isAfrican
//                                     ? balanceSnap.data?.xaf
//                                     : balanceSnap.data?.eur,
//                               )
//                             : '...';

//                         if (isFundsInsufficient == true) {
//                           text = LocaleKeys
//                               .wallet_module_common_insufficient_funds
//                               .tr();
//                         }
//                         return Text(
//                           text,
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: colorScheme.onPrimary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (isFundsInsufficient == true)
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFBAB9B9),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       LocaleKeys
//                           .wallet_module_buy_beatzcoins_page_modal_insufficient_funds
//                           .tr(),
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Color(0xFFFC0909),
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ActionButton(
//                       onPressed: Modular.get<WalletRoutes>().deposit.navigate,
//                       text: LocaleKeys
//                           .wallet_module_buy_beatzcoins_page_modal_add_funds
//                           .tr(),
//                       backgroundColor: colorScheme.primary,
//                       textColor: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             if (isFundsInsufficient == false)
//               Row(
//                 children: [
//                   Flexible(
//                     child: ActionButton(
//                       enabled: !isProcessing,
//                       onPressed: Navigator.of(context).pop,
//                       text: LocaleKeys.wallet_module_common_cancel.tr(),
//                       backgroundColor: Colors.black,
//                       textColor: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Flexible(
//                     child: Visibility(
//                       visible: !isProcessing,
//                       replacement: const Center(
//                         child: CircularProgressIndicator.adaptive(),
//                       ),
//                       child: ActionButton(
//                         enabled: !isProcessing,
//                         onPressed: onPayWithBantubeat,
//                         text: LocaleKeys.wallet_module_common_buy.tr(),
//                         backgroundColor: colorScheme.primary,
//                         textColor: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             /*
//             SizedBox(height: 20),
//             ActionButton(
//               enabled: !isProcessing,
//               onPressed: onPayWithApple,
//               fullWidth: true,
//               prefixIcon: Icon(Icons.apple, color: Colors.black, size: 28),
//               text: 'Pay',
//               backgroundColor: Colors.white,
//               textColor: Colors.black,
//             ),
//             SizedBox(height: 20),
//             ActionButton(
//               enabled: !isProcessing,
//               onPressed: onPayWithGoogle,
//               fullWidth: true,
//               prefixIcon: GoogleIconSvgImage(width: 20),
//               text: ' Pay',
//               backgroundColor: Colors.white,
//               textColor: Colors.black,
//             ),
//             SizedBox(height: 20),
//             Text(
//               LocaleKeys.wallet_module_buy_beatzcoins_page_modal_warning1.tr(),
//               style: TextStyle(fontSize: 12, color: Color(0xFF181818)),
//             ),  */
//             const SizedBox(height: 10),
//             Center(
//               child: Text.rich(
//                 textAlign: TextAlign.center,
//                 TextSpan(
//                   text: LocaleKeys
//                       .wallet_module_buy_beatzcoins_page_modal_warning2a
//                       .tr(),
//                   style:
//                       const TextStyle(fontSize: 12, color: Color(0xFF181818)),
//                   children: [
//                     TextSpan(
//                       text: LocaleKeys
//                           .wallet_module_buy_beatzcoins_page_modal_warning2b
//                           .tr(),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: colorScheme.primary,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(
//                             Uri.parse(
//                               'https://legal.bantubeat.com/bantubeat/help-center?index=12',
//                             ),
//                             mode: LaunchMode.externalApplication,
//                           );
//                         },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
