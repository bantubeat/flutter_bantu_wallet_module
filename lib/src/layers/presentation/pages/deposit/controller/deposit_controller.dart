import 'package:flutter_bantu_wallet_module/src/core/network/my_http/my_http.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_payment_method.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import 'package:intl/intl.dart';
import '../../../../../core/use_cases/use_case.dart';

import '../../../../domain/entities/currency_item_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/use_cases/currency/get_all_currencies_use_case.dart';
import '../../../../domain/use_cases/account/get_current_user_use_case.dart';

import 'payment_mixins/pay_with_bantubeat.dart';
import 'payment_mixins/pay_with_google.dart';

class DepositController extends ScreenController
    with PayWithBantubeat, PayWithGoogle {
  DepositController(super.state);

  static const feesPercent = 5.0;

  /// Devises traitées via carte / PayPal / Google Pay (zone "Autres").
  /// Tout ce qui n'est pas dans cette liste est considéré comme une
  /// devise "locale" (zone monétaire de l'utilisateur : CEMAC, UEMOA, etc.)
  static const cardZoneCurrencies = ['EUR', 'USD'];

  List<CurrencyItemEntity> _allCurrencies = [];
  final selectedCurrencyTextCtrl = TextEditingController();

  /// true = zone locale (paiement via flutterwave dans la devise de la
  /// monetaryZone de l'utilisateur), false = zone carte (EUR/USD).
  bool _isLocalZone = false;

  final amountCtrl = TextEditingController();
  UserEntity? currentUser;

  @override
  @protected
  void onInit() {
    Future.wait([
      Modular.get<GetCurrentUserUseCase>().call(NoParms()).then((data) {
        currentUser = data;
        // La zone par défaut dépend uniquement de la présence d'une
        // monetaryZone renvoyée par le backend pour l'utilisateur connecté.
        _isLocalZone = data.monetaryZone != null;
        _selectDefaultCurrency();
        refreshUI();
      }),
      Modular.get<GetAllCurrenciesUseCase>().call(NoParms()).then((data) {
        _allCurrencies = data;
        _selectDefaultCurrency();
        if (selectedCurrencyTextCtrl.text.isEmpty) {
          selectedCurrencyTextCtrl.text = data.firstOrNull?.code ?? '';
        }
        refreshUI();
      }),
    ]);
    amountCtrl.addListener(refreshUI);
  }

  @override
  @protected
  void onDispose() {
    amountCtrl.dispose();
  }

  bool get initialized => _allCurrencies.isNotEmpty && currentUser != null;

  CurrencyItemEntity? get _selectedCurrency {
    return _allCurrencies
        .where((c) => c.code == selectedCurrencyTextCtrl.text)
        .firstOrNull;
  }

  /// Devises "locales" disponibles (tout sauf EUR/USD) — zone Afrique.
  List<CurrencyItemEntity> get localCurrencies => _allCurrencies
      .where((c) => !cardZoneCurrencies.contains(c.code))
      .toList();

  /// Devises "carte" disponibles (EUR/USD) — zone Autres.
  List<CurrencyItemEntity> get cardCurrencies =>
      _allCurrencies.where((c) => cardZoneCurrencies.contains(c.code)).toList();

  /// Liste à afficher dans le dropdown, selon la zone active.
  List<CurrencyItemEntity> get selectableCurrencies =>
      _isLocalZone ? localCurrencies : cardCurrencies;

  String? get selectedCurrencyCode => _selectedCurrency?.code;

  // bool get isLocalZone => false;
  bool get isLocalZone => _isLocalZone;

  String get currency =>
      _selectedCurrency?.code ??
      (_isLocalZone
          ? (currentUser?.monetaryZone?.currencyIso ?? 'XAF')
          : 'EUR');

  double get _amount => double.tryParse(amountCtrl.text) ?? 0;

  double get _fees => _isLocalZone ? _amount * feesPercent / 100 : 0;

  double get _total => _amount + _fees;

  NumberFormat get _amountFormatter {
    final currCode = _selectedCurrency?.code;
    if (currCode == null) return NumberFormat();
    switch (currCode) {
      case 'USD':
        return NumberFormat.currency(
          locale: 'en_US',
          name: 'USD',
          symbol: r'$',
        );
      case 'EUR':
        return NumberFormat.currency(
          locale: 'fr_FR',
          name: 'EUR',
          symbol: '€',
        );
      case 'XAF':
      case 'XOF':
        return NumberFormat.currency(
          locale: 'fr_CM',
          name: currCode,
          symbol: currentUser?.monetaryZone?.currencySymbol ?? 'F.CFA',
        );
      case 'NGN':
        return NumberFormat.currency(
          locale: 'en_NG',
          name: currCode,
          symbol: '₦',
        );
      default:
        return NumberFormat.currency(name: currCode);
    }
  }

  String get formattedAmount => _amountFormatter.format(_amount);

  String get formattedFees => _amountFormatter.format(_fees);

  String get formattedTotal => _amountFormatter.format(_total);

  /// Label affiché dans le sélecteur pour une devise donnée. Pour la
  /// devise de la monetaryZone de l'utilisateur, on utilise le nom de la
  /// devise + le nom de la zone renvoyés par le backend
  /// (ex: "XAF (Franc CFA CEMAC)"). Pour EUR/USD, libellé standard.
  String currencyLabel(CurrencyItemEntity curr) {
    final zone = currentUser?.monetaryZone;
    if (zone != null && zone.currencyIso == curr.code) {
      final name =
          [zone.currencyName, zone.name].where((s) => s.isNotEmpty).join(' ');
      return name.isEmpty ? curr.code : '${curr.code} ($name)';
    }
    if (curr.code == 'EUR') return 'EURO (€)';
    if (curr.code == 'USD') return 'DOLLAR (\$)';
    return '${curr.code} (${curr.description})';
  }

  void _selectDefaultCurrency() {
    if (currentUser == null || _allCurrencies.isEmpty) return;

    if (_isLocalZone) {
      final zoneCurrencyIso = currentUser?.monetaryZone?.currencyIso;
      final match = zoneCurrencyIso == null
          ? null
          : _allCurrencies.where((c) => c.code == zoneCurrencyIso).firstOrNull;
      selectedCurrencyTextCtrl.text =
          match?.code ?? localCurrencies.firstOrNull?.code ?? '';
      return;
    }

    final defaultCardCode =
        ['US', 'CA'].contains(currentUser?.pays ?? '') ? 'USD' : 'EUR';
    final match =
        cardCurrencies.where((c) => c.code == defaultCardCode).firstOrNull;
    selectedCurrencyTextCtrl.text =
        match?.code ?? cardCurrencies.firstOrNull?.code ?? defaultCardCode;
  }

  void selectCurrency(String curr) {
    selectedCurrencyTextCtrl.text = curr;
    refreshUI();
  }

  void switchZone() {
    _isLocalZone = !_isLocalZone;
    amountCtrl.clear();
    _selectDefaultCurrency();
    refreshUI();
  }

  void onGooglePay() async {
    final currency = _selectedCurrency?.code.toUpperCase();
    final amount = num.tryParse(amountCtrl.text)?.toDouble();
    final countryIso2 = currentUser?.pays.toUpperCase();
    if (countryIso2 == null || currency == null || amount == null) {
      return UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
      );
    }

    payWithGoogle(amount: amount, countryIso2: countryIso2, currency: currency);
  }

  void onApplePay() async {
    final currency = _selectedCurrency?.code.toUpperCase();
    final amount = num.tryParse(amountCtrl.text)?.toDouble();
    if (currency == null || amount == null) {
      return UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
      );
    }
  }

  void onPayPal() async {
    final amount = num.tryParse(amountCtrl.text)?.toDouble();
    if (amount == null) {
      return UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
      );
    }

    return payWithBantubeat(context, EPaymentMethod.paypal, amount);
  }

  void onCreditOrVisaCard() async {
    final amount = num.tryParse(amountCtrl.text)?.toDouble();
    if (amount == null) {
      return UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
      );
    }

    payWithBantubeat(context, EPaymentMethod.stripe, amount);
  }

  void onContinue() {
    try {
      if (_isLocalZone) {
        final user = currentUser;
        final currency = _selectedCurrency?.code.toUpperCase();
        final amount = num.tryParse(amountCtrl.text)?.toDouble();

        if (user == null || currency == null || amount == null) {
          return UiAlertHelpers.showErrorSnackBar(
            context,
            LocaleKeys.wallet_module_deposit_page_amount_and_currency_required
                .tr(),
          );
        }

        payWithBantubeat(context, EPaymentMethod.flutterwave, amount, currency);
      }
    } catch (e) {
      if (e is MyHttpException) {
        UiAlertHelpers.showErrorToast(
          e.message ?? e.toString(),
        );
      } else {
        UiAlertHelpers.showErrorToast(
          e.toString(),
        );
      }
    }
  }
}
// import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_payment_method.dart';
// import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:flutter_screen_controller/flutter_screen_controller.dart';
// import 'package:intl/intl.dart';
// import '../../../../../core/use_cases/use_case.dart';

// import '../../../../../core/config/countries.dart';
// import '../../../../domain/entities/currency_item_entity.dart';
// import '../../../../domain/entities/user_entity.dart';
// import '../../../../domain/use_cases/currency/get_all_currencies_use_case.dart';
// import '../../../../domain/use_cases/account/get_current_user_use_case.dart';

// import 'payment_mixins/pay_with_bantubeat.dart';
// import 'payment_mixins/pay_with_google.dart';

// class DepositController extends ScreenController
//     with PayWithBantubeat, PayWithGoogle {
//   DepositController(super.state);

//   static const feesPercent = 5.0;

//   static const nonAfricanCurrenciesCode = ['EUR', 'USD'];

//   List<CurrencyItemEntity> _allCurrencies = [];
//   final selectedCurrencyTextCtrl = TextEditingController();
//   bool _isAfricanZone = false;
//   final amountCtrl = TextEditingController();
//   UserEntity? currentUser;

//   @override
//   @protected
//   void onInit() {
//     Future.wait([
//       Modular.get<GetCurrentUserUseCase>().call(NoParms()).then((data) {
//         currentUser = data;
//         _isAfricanZone = data.isAfrican;
//         _selectDefaultUserCountryCurrencyIfAvailable();
//         refreshUI();
//       }),
//       Modular.get<GetAllCurrenciesUseCase>().call(NoParms()).then((data) {
//         _allCurrencies = data;
//         _selectDefaultUserCountryCurrencyIfAvailable();
//         if (selectedCurrencyTextCtrl.text.isEmpty) {
//           selectedCurrencyTextCtrl.text = data.firstOrNull?.code ?? '';
//         }
//         switchZone();
//       }),
//     ]);
//     amountCtrl.addListener(refreshUI);
//   }

//   @override
//   @protected
//   void onDispose() {
//     amountCtrl.dispose();
//   }

//   bool get initialized => _allCurrencies.isNotEmpty && currentUser != null;

//   CurrencyItemEntity? get _selectedCurrency {
//     return _allCurrencies
//         .where((c) => c.code == selectedCurrencyTextCtrl.text)
//         .firstOrNull;
//   }

//   List<CurrencyItemEntity> get africanCurrencies {
//     final africans = africanCountryCurrencyList.map((e) => e.currency);
//     return _allCurrencies.where((c) => africans.contains(c.code)).toList();
//   }

//   String? get selectedCurrencyCode => _selectedCurrency?.code;

//   bool get isAfricanZone => _isAfricanZone;

//   String get currency => _isAfricanZone ? (selectedCurrencyCode ?? 'XAF') : '€';

//   double get _amount => double.tryParse(amountCtrl.text) ?? 0;

//   double get _fees => _isAfricanZone ? _amount * 5 / 100 : 0;

//   double get _total => _amount + _fees;

//   NumberFormat get _amountFormatter {
//     final currCode = _selectedCurrency?.code;
//     if (currCode == null) return NumberFormat();
//     switch (currCode) {
//       case 'USD':
//         return NumberFormat.currency(
//           locale: 'en_US',
//           name: 'USD',
//           symbol: r'$',
//         );
//       case 'EUR':
//         return NumberFormat.currency(
//           locale: 'fr_FR',
//           name: 'EUR',
//           symbol: '€',
//         );
//       case 'XAF':
//       case 'XOF':
//         return NumberFormat.currency(
//           locale: 'fr_CM',
//           name: currCode,
//           symbol: 'F.CFA',
//         );
//       case 'NGN':
//         return NumberFormat.currency(
//           locale: 'en_NG',
//           name: currCode,
//           symbol: '₦',
//         );

//       default:
//         return NumberFormat.currency(name: currCode);
//     }
//   }

//   String get formattedAmount => _amountFormatter.format(_amount);

//   String get formattedFees => _amountFormatter.format(_fees);

//   String get formattedTotal => _amountFormatter.format(_total);

//   void _selectDefaultUserCountryCurrencyIfAvailable() {
//     if (currentUser?.pays == null || _allCurrencies.isEmpty) return;

//     if (!_isAfricanZone) {
//       if (['US', 'CA'].contains(currentUser?.pays ?? '')) {
//         selectedCurrencyTextCtrl.text = 'USD';
//       } else {
//         selectedCurrencyTextCtrl.text = 'EUR';
//       }
//       return;
//     }

//     final currency = africanCountryCurrencyList
//             .where((e) => e.iso2 == currentUser?.pays)
//             .firstOrNull
//             ?.currency ??
//         'XAF';
//     selectedCurrencyTextCtrl.text = _allCurrencies
//         .singleWhere(
//           (c) => c.code == currency,
//           orElse: () => _allCurrencies.first,
//         )
//         .code;
//   }

//   void selectCurrency(String curr) {
//     selectedCurrencyTextCtrl.text = curr;
//     refreshUI();
//   }

//   void switchZone() {
//     _isAfricanZone = !_isAfricanZone;
//     amountCtrl.clear();
//     if (_selectedCurrency != null) {
//       if (_isAfricanZone && !africanCurrencies.contains(_selectedCurrency)) {
//         _selectDefaultUserCountryCurrencyIfAvailable();
//         if (selectedCurrencyTextCtrl.text.isEmpty) {
//           selectedCurrencyTextCtrl.text =
//               africanCurrencies.firstOrNull?.code ?? '';
//         }
//       }
//       if (!_isAfricanZone && africanCurrencies.contains(_selectedCurrency)) {
//         selectCurrency(
//           _allCurrencies
//               .firstWhere(
//                 (curr) => nonAfricanCurrenciesCode.contains(curr.code),
//                 orElse: CurrencyItemEntity.none,
//               )
//               .code,
//         );
//       }
//     }
//     refreshUI();
//   }

//   void onGooglePay() async {
//     final currency = _selectedCurrency?.code.toUpperCase();
//     final amount = num.tryParse(amountCtrl.text)?.toDouble();
//     final countryIso2 = currentUser?.pays.toUpperCase();
//     if (countryIso2 == null || currency == null || amount == null) {
//       return UiAlertHelpers.showErrorSnackBar(
//         context,
//         LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
//       );
//     }

//     payWithGoogle(amount: amount, countryIso2: countryIso2, currency: currency);
//   }

//   void onApplePay() async {
//     final currency = _selectedCurrency?.code.toUpperCase();
//     final amount = num.tryParse(amountCtrl.text)?.toDouble();
//     if (currency == null || amount == null) {
//       return UiAlertHelpers.showErrorSnackBar(
//         context,
//         LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
//       );
//     }
//   }

//   void onPayPal() async {
//     final amount = num.tryParse(amountCtrl.text)?.toDouble();
//     if (amount == null) {
//       return UiAlertHelpers.showErrorSnackBar(
//         context,
//         LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
//       );
//     }

//     return payWithBantubeat(context, EPaymentMethod.paypal, amount);
//   }

//   void onCreditOrVisaCard() async {
//     final amount = num.tryParse(amountCtrl.text)?.toDouble();
//     if (amount == null) {
//       return UiAlertHelpers.showErrorSnackBar(
//         context,
//         LocaleKeys.wallet_module_deposit_page_amount_and_currency_required.tr(),
//       );
//     }

//     payWithBantubeat(context, EPaymentMethod.stripe, amount);
//   }

//   void onContinue() {
//     if (_isAfricanZone) {
//       final user = currentUser;
//       final currency = _selectedCurrency?.code.toUpperCase();
//       final amount = num.tryParse(amountCtrl.text)?.toDouble();

//       if (user == null || currency == null || amount == null) {
//         return UiAlertHelpers.showErrorSnackBar(
//           context,
//           LocaleKeys.wallet_module_deposit_page_amount_and_currency_required
//               .tr(),
//         );
//       }

//       payWithBantubeat(context, EPaymentMethod.flutterwave, amount, currency);
//       // return payWithFlutterwave(context, user, currency, amount);
//     }
//   }
// }
