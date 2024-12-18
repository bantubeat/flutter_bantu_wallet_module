// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_modular/flutter_modular.dart';

final class WalletRoutes {
  final String prefix_;
  final String _home;
  final String _balance;
  final String _deposit;
  final String _withdrawal;
  final String _beatzcoins;
  final String _buyBeatzcoins;
  final String _transactions;

  const WalletRoutes(
    this.prefix_, {
    String home = 'home',
    String balance = 'balance',
    String deposit = 'deposit',
    String withdrawal = 'withdrawal',
    String beatzcoins = 'beatzcoins',
    String buyBeatzcoins = 'buy-beatzcoins',
    String transactions = 'transactions-history',
  })  : _home = home,
        _balance = balance,
        _deposit = deposit,
        _withdrawal = withdrawal,
        _beatzcoins = beatzcoins,
        _buyBeatzcoins = buyBeatzcoins,
        _transactions = transactions;

  _RouteItem get home => _RouteItem(prefix_, _home);
  _RouteItem get balance => _RouteItem(prefix_, _balance);
  _RouteItem get deposit => _RouteItem(prefix_, _deposit);
  _RouteItem get withdrawal => _RouteItem(prefix_, _withdrawal);
  _RouteItem get beatzcoins => _RouteItem(prefix_, _beatzcoins);
  _RouteItem get buyBeatzcoins => _RouteItem(prefix_, _buyBeatzcoins);
  _RouteItem get transactions => _RouteItem(prefix_, _transactions);
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
