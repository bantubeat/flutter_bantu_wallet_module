import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show EventChannel;
import 'package:pay/pay.dart';

import '../../../../../layers/presentation/pages/deposit/controller/deposit_controller.dart';
import '../../../helpers/ui_alert_helpers.dart';

/// Bouton Google Pay qui lit le montant courant au moment du tap (et non au
/// moment de la création du widget).
///
/// Le `GooglePayButton` du plugin `pay` s'abonne à l'EventChannel
/// `plugins.flutter.io/pay/payment_result` une seule fois (dans `initState`)
/// et livre le résultat via ce même flux. Le listener capturé référence le
/// premier widget construit, donc le montant figé au moment où le bouton est
/// apparu (ex. "100" → "1"). On reproduit ici l'abonnement à l'EventChannel
/// tout en relisant le montant dans le controller au moment du paiement.
///
/// Exemple d'utilisation :
/// ```dart
/// // Dans le `build` de `EUPaymentOptions`, à la place de `GooglePayButton`.
/// // Le widget reste monté en permanence : l'EventChannel est donc abonné une
/// // seule fois et le montant est relu depuis `ctrl` à chaque paiement.
/// final amount = num.tryParse(ctrl.amountCtrl.text)?.toDouble() ?? 0.0;
/// GooglePayLiveButton(
///   ctrl: ctrl,
///   enabled: amount > 0,
///   onDisabledTap: () => UiAlertHelpers.showErrorSnackBar(
///     context,
///     LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
///   ),
/// )
/// ```
class GooglePayLiveButton extends StatefulWidget {
  const GooglePayLiveButton({
    required this.ctrl,
    this.enabled = true,
    this.onDisabledTap,
    super.key,
  });

  final DepositController ctrl;

  /// Quand `false`, le bouton est affiché mais estompé et non cliquable.
  /// Le widget reste néanmoins monté pour conserver l'abonnement à
  /// l'EventChannel.
  final bool enabled;

  /// Appelé lorsqu'on tape sur le bouton alors que [enabled] est `false`.
  final VoidCallback? onDisabledTap;

  @override
  State<GooglePayLiveButton> createState() => _GooglePayLiveButtonState();
}

class _GooglePayLiveButtonState extends State<GooglePayLiveButton> {
  static const _eventChannel =
      EventChannel('plugins.flutter.io/pay/payment_result');

  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _eventChannel
        .receiveBroadcastStream()
        .cast<String>()
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .listen(_onPaymentResult, onError: _onError);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  void _onPaymentResult(Map<String, dynamic> result) {
    final ctrl = widget.ctrl;
    final amount = num.tryParse(ctrl.amountCtrl.text)?.toDouble() ?? 0;
    final currency = ctrl.selectedCurrencyCode?.toUpperCase();
    if (currency == null || amount <= 0) return;
    ctrl.onGooglePayResult(result, amount: amount, currency: currency);
  }

  void _onError(Object error) {
    debugPrint('Google Pay Error: $error');
    UiAlertHelpers.showErrorToast('$error');
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.ctrl;
    final country = ctrl.currentUser?.pays.toUpperCase();
    final currency = ctrl.selectedCurrencyCode?.toUpperCase();
    if (country == null || currency == null) {
      return const SizedBox.shrink();
    }

    final button = SizedBox(
      height: 50,
      child: RawGooglePayButton(
        paymentConfiguration: ctrl.getGooglePaymentConfiguration(
          countryIso2: country,
          currency: currency,
        ),
        cornerRadius: 8,
        type: GooglePayButtonType.pay,
        onPressed: ctrl.onGooglePay,
        theme: Theme.of(context).colorScheme.brightness == Brightness.dark
            ? GooglePayButtonTheme.light
            : GooglePayButtonTheme.dark,
      ),
    );

    if (!widget.enabled) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onDisabledTap,
        child: IgnorePointer(
          child: Opacity(
            opacity: 0.5,
            child: button,
          ),
        ),
      );
    }

    return button;
  }
}
