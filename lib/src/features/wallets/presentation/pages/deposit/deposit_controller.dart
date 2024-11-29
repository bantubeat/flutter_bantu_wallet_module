import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';

import '../../../domain/entities/currency_item.dart';
import '../../../domain/use_cases/get_all_currencies_use_case.dart';

class DepositController extends ScreenController {
  DepositController(super.state);

  static const feesPercent = 5.0;

  static const nonAfricanCurrenciesCode = ['EUR', 'USD'];

  List<CurrencyItem> _allCurrencies = [];
  CurrencyItem? _selectedCurrency;
  bool _isAfricanZone = false; // TODO: put the opposite of loggedIn user
  final amountCtrl = TextEditingController();

  @override
  @protected
  void onInit() {
    Modular.get<GetAllCurrenciesUseCase>().call(null).then((data) {
      _allCurrencies = data;
      _selectedCurrency = data.firstOrNull;
      switchZone();
    });
    amountCtrl.addListener(refreshUI);
  }

  @override
  @protected
  void onDispose() {
    amountCtrl.dispose();
  }

  List<CurrencyItem> get africanCurrencies {
    return _allCurrencies.skipWhile((currency) {
      return nonAfricanCurrenciesCode.contains(currency.code);
    }).toList();
  }

  void setSelectedCurrency(String code) {
    _selectedCurrency = _allCurrencies.where((c) => c.code == code).firstOrNull;
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
        return NumberFormat.currency(locale: 'fr_FR', name: 'EUR', symbol: '€');
      case 'XAF':
      case 'XOF':
        return NumberFormat.currency(symbol: 'F.CFA');
      case 'NGN':
        return NumberFormat.currency(symbol: '₦');

      default:
        return NumberFormat.currency(name: currCode);
    }
  }

  String get formattedAmount => _amountFormatter.format(_amount);

  String get formattedFees => _amountFormatter.format(_fees);

  String get formattedTotal => _amountFormatter.format(_total);

  void switchZone() {
    _isAfricanZone = !_isAfricanZone;
    if (_selectedCurrency != null) {
      if (_isAfricanZone && !africanCurrencies.contains(_selectedCurrency)) {
        _selectedCurrency = africanCurrencies.firstOrNull;
      }
      if (!_isAfricanZone && africanCurrencies.contains(_selectedCurrency)) {
        _selectedCurrency = _allCurrencies.firstWhere(
          (curr) => nonAfricanCurrenciesCode.contains(curr.code),
          orElse: CurrencyItem.none,
        );
      }
    }
    refreshUI();
  }

  void onGooglePay() async {}

  void onApplePay() async {}

  void onPayPal() async {}

  void onCreditOrVisaCard() async {}

  void onContinue() async {}
}
