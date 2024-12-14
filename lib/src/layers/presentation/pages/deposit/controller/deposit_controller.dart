import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/e_payment_method.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import '../../../../../core/use_cases/use_case.dart';

import '../../../../../core/utils/countries.dart';
import '../../../../domain/entities/currency_item_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/use_cases/get_all_currencies_use_case.dart';
import '../../../../domain/use_cases/get_current_user_use_case.dart';

import 'payment_mixins/pay_with_bantubeat.dart';
import 'payment_mixins/pay_with_google.dart';

class DepositController extends ScreenController
    with PayWithBantubeat, PayWithGoogle {
  DepositController(super.state);

  static const feesPercent = 5.0;

  static const nonAfricanCurrenciesCode = ['EUR', 'USD'];

  List<CurrencyItemEntity> _allCurrencies = [];
  final selectedCurrencyTextCtrl = TextEditingController();
  bool _isAfricanZone = false;
  final amountCtrl = TextEditingController();
  UserEntity? currentUser;

  @override
  @protected
  void onInit() {
    Modular.get<GetCurrentUserUseCase>().call(NoParms()).then((data) {
      currentUser = data;
      _isAfricanZone = data.isAfrican;
      _selectDefaultUserCountryCurrencyIfAvailable();
      refreshUI();
    });
    Modular.get<GetAllCurrenciesUseCase>().call(NoParms()).then((data) {
      _allCurrencies = data;
      _selectDefaultUserCountryCurrencyIfAvailable();
      if (selectedCurrencyTextCtrl.text.isEmpty) {
        selectedCurrencyTextCtrl.text = data.firstOrNull?.code ?? '';
      }
      switchZone();
    });
    amountCtrl.addListener(refreshUI);
  }

  @override
  @protected
  void onDispose() {
    amountCtrl.dispose();
  }

  CurrencyItemEntity? get _selectedCurrency {
    return _allCurrencies
        .where((c) => c.code == selectedCurrencyTextCtrl.text)
        .firstOrNull;
  }

  List<CurrencyItemEntity> get africanCurrencies {
    final africans = africanCountryCurrencyList.map((e) => e.currency);
    return _allCurrencies.where((c) => africans.contains(c.code)).toList();
  }

  String? get selectedCurrencyCode => _selectedCurrency?.code;

  bool get isAfricanZone => _isAfricanZone;

  String get currency => _isAfricanZone ? (selectedCurrencyCode ?? 'XAF') : '€';

  double get _amount => double.tryParse(amountCtrl.text) ?? 0;

  double get _fees => _isAfricanZone ? _amount * 5 / 100 : 0;

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
          symbol: 'F.CFA',
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

  void _selectDefaultUserCountryCurrencyIfAvailable() {
    if (currentUser?.pays == null || _allCurrencies.isEmpty) return;

    final currency = africanCountryCurrencyList
        .where((e) => e.iso2 == currentUser?.pays)
        .firstOrNull
        ?.currency;
    selectedCurrencyTextCtrl.text = _allCurrencies
        .singleWhere(
          (c) => c.code == currency,
          orElse: () => _allCurrencies.first,
        )
        .code;
  }

  void selectCurrency(String curr) {
    selectedCurrencyTextCtrl.text = curr;
    refreshUI();
  }

  void switchZone() {
    _isAfricanZone = !_isAfricanZone;
    amountCtrl.clear();
    if (_selectedCurrency != null) {
      if (_isAfricanZone && !africanCurrencies.contains(_selectedCurrency)) {
        _selectDefaultUserCountryCurrencyIfAvailable();
        if (selectedCurrencyTextCtrl.text.isEmpty) {
          selectedCurrencyTextCtrl.text =
              africanCurrencies.firstOrNull?.code ?? '';
        }
      }
      if (!_isAfricanZone && africanCurrencies.contains(_selectedCurrency)) {
        selectCurrency(
          _allCurrencies
              .firstWhere(
                (curr) => nonAfricanCurrenciesCode.contains(curr.code),
                orElse: CurrencyItemEntity.none,
              )
              .code,
        );
      }
    }
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
    if (_isAfricanZone) {
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
      // return payWithFlutterwave(context, user, currency, amount);
    }
  }
}
