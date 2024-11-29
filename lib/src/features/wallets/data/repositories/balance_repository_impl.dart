import 'package:flutter/material.dart';

import '../../domain/entities/user_balance.dart';
import '../../domain/repositories/balance_repository.dart';
import '../data_sources/bantubeat_api_data_source.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final BantubeatApiDataSource _bantubeatApiDataSource;

  BalanceRepositoryImpl(this._bantubeatApiDataSource);

  @override
  Future<UserBalance> getUserBalance() async {
    try {
      final userModel = await _bantubeatApiDataSource.get$balance();
      return userModel; // since UserBalanceModel extends UserBalance
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      rethrow;
    }
  }
}
