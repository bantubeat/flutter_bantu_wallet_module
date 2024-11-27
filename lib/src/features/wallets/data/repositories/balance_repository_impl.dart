import 'package:flutter/material.dart';

import '../../domain/entities/user_balance.dart';
import '../../domain/repositories/balance_repository.dart';
import '../data_sources/balance_remote_data_source.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceRemoteDataSourceImpl remoteDataSource;

  BalanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserBalance> getUserBalance() async {
    try {
      final userModel = await remoteDataSource.getUserBalance();
      return userModel; // since UserBalanceModel extends UserBalance
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      rethrow;
    }
  }
}
