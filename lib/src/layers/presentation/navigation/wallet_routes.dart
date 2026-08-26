// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/value_objects/requests/create_withdrawal_request.dart';

final class WalletRoutes {
  final String prefix_;
  final String _home;
  final String _monetisationProgramHome;
  final String _balance;
  final String _deposit;
  final String _withdrawal;
  final String _beatzcoins;
  final String _buyBeatzcoins;
  final String _transactions;
  final String _addOrEditPaymentAccount;
  final String _withdrawalRequestForm;
  final String _withdrawalRequestResume;
  final String _verifiePaiementAccount;
  final String _taxIdentifier;

  const WalletRoutes(
    this.prefix_, {
    String home = 'home',
    String monetisationProgramHome = 'monetisation-program-home',
    String balance = 'balance',
    String deposit = 'deposit',
    String withdrawal = 'withdrawal',
    String beatzcoins = 'beatzcoins',
    String buyBeatzcoins = 'buy-beatzcoins',
    String transactions = 'transactions-history',
    String addOrEditPaymentAccount = 'add-or-edit-payment-account',
    String withdrawalRequestForm = 'withdrawal-request-form',
    String withdrawalRequestResume = 'withdrawal-request-resume',
    String verifiePaiementAccount = 'verifie-paiement-account',
    String taxIdentifier = 'tax-identifier',
  })  : _home = home,
        _monetisationProgramHome = monetisationProgramHome,
        _balance = balance,
        _deposit = deposit,
        _withdrawal = withdrawal,
        _beatzcoins = beatzcoins,
        _buyBeatzcoins = buyBeatzcoins,
        _transactions = transactions,
        _addOrEditPaymentAccount = addOrEditPaymentAccount,
        _withdrawalRequestForm = withdrawalRequestForm,
        _withdrawalRequestResume = withdrawalRequestResume,
        _verifiePaiementAccount = verifiePaiementAccount,
        _taxIdentifier = taxIdentifier;

  _RouteItem get home => _RouteItem(prefix_, _home);
  _RouteItem get monetisationProgramHome =>
      _RouteItem(prefix_, _monetisationProgramHome);
  _RouteItem get balance => _RouteItem(prefix_, _balance);
  _RouteItem get deposit => _RouteItem(prefix_, _deposit);
  _RouteItem get withdrawal => _RouteItem(prefix_, _withdrawal);
  _RouteItem get beatzcoins => _RouteItem(prefix_, _beatzcoins);
  _RouteItem get buyBeatzcoins => _RouteItem(prefix_, _buyBeatzcoins);
  _RouteItem get transactions => _RouteItem(prefix_, _transactions);
  _RouteItem get addOrEditPaymentAccount =>
      _RouteItem(prefix_, _addOrEditPaymentAccount);
  _RouteItem get withdrawalRequestForm =>
      _RouteItem(prefix_, _withdrawalRequestForm);
  _RouteItem<CreateWithdrawalRequest> get withdrawalRequestResume =>
      _RouteItem<CreateWithdrawalRequest>(prefix_, _withdrawalRequestResume);
  _RouteItem<PaymentPreferenceEntity> get verifiePaiementAccount =>
      _RouteItem<PaymentPreferenceEntity>(prefix_, _verifiePaiementAccount);
  _RouteItem get taxIdentifier => _RouteItem(prefix_, _taxIdentifier);
}

final class _RouteItem<T> {
  final String _prefix;
  final String _route;

  _RouteItem(this._prefix, String route)
      : _route = route.startsWith('/') ? route.replaceFirst('/', '') : route;

  // Without prefix
  String get wp {
    //final r = _route.replaceFirst(_prefix, '');
    return _route.startsWith('/') ? _route : '/$_route';
  }

  @override
  String toString() {
    final r = '$_prefix/$_route'.replaceAll('//', '/');
    return r.startsWith('/') ? r : '/$r';
  }

  void navigate([T? arguments]) {
    return Modular.to.navigate(toString(), arguments: arguments);
  }

  Future<P?> push<P extends Object?>([
    T? arguments,
    Map<String, String>? params,
  ]) {
    var path = toString();
    if (params != null && params.isNotEmpty) {
      final query = params.keys.map((k) {
        final val = params[k];
        return (val?.isNotEmpty ?? false) ? 'k=$val' : '';
      }).join('&');

      if (query.isNotEmpty) path += '?$query';
    }
    return Modular.to.pushNamed(path, arguments: arguments);
  }
}
