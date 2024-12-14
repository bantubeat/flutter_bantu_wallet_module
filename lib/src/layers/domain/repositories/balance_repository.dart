import '../entities/e_withdrawal_eligibility.dart';
import '../entities/exchange_bzc_pack_entity.dart';
import '../entities/payment_preference_entity.dart';
import '../entities/financial_transaction_entity.dart';
import '../entities/user_balance_entity.dart';

abstract class BalanceRepository {
  Future<UserBalanceEntity> getUserBalance();

  Future<List<ExchangeBzcPackEntity>> getExchangeBzcPacks();

  Future<List<PaymentPreferenceEntity>> getPaymentPreferences();

  Future<List<FinancialTransactionEntity>> getTransactions({
    required int limit,
    int page = 1,
    List<EFinancialTxStatus>? statusList,
    List<EFinancialTxType>? typesList,
    bool? isBzcAccount,
  });

  Future<EWithdrawalEligibility> checkWithdrawalEligibility();
}
