import 'package:flutter/foundation.dart' show debugPrintStack;

import '../../domain/entities/e_withdrawal_eligibility.dart';
import '../../domain/entities/exchange_bzc_pack_entity.dart';
import '../../domain/entities/payment_preference_entity.dart';
import '../../domain/entities/financial_transaction_entity.dart';
import '../../domain/entities/user_balance_entity.dart';
import '../../domain/repositories/balance_repository.dart';
import '../data_sources/bantubeat_api_data_source.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  final BantubeatApiDataSource _apiDataSource;

  BalanceRepositoryImpl(this._apiDataSource);

  @override
  Future<UserBalanceEntity> getUserBalance() async {
    try {
      final userModel = await _apiDataSource.get$balance();
      return userModel; // since UserBalanceModel extends UserBalance
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<EWithdrawalEligibility> checkWithdrawalEligibility() {
    return _apiDataSource.get$checkWithdrawalEligibilityStatus();
  }

  @override
  Future<List<ExchangeBzcPackEntity>> getExchangeBzcPacks() {
    return _apiDataSource.get$publicExchangeBzcPacks();
  }

  @override
  Future<List<PaymentPreferenceEntity>> getPaymentPreferences() {
    return _apiDataSource.get$paymentPreferences();
  }

  @override
  Future<List<FinancialTransactionEntity>> getTransactions({
    required int limit,
    int page = 1,
    List<EFinancialTxStatus>? statusList,
    List<EFinancialTxType>? typesList,
    bool? isBzcAccount,
  }) {
    return _apiDataSource.get$transactions(
      limit: limit,
      page: page,
      statusList: statusList,
      typesList: typesList,
      isBzcAccount: isBzcAccount,
    );
  }
}
