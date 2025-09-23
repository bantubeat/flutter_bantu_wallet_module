import '../entities/enums/e_withdrawal_eligibility.dart';
import '../entities/enums/e_withdrawal_response_status.dart';
import '../entities/exchange_bzc_pack_entity.dart';
import '../entities/payment_preference_entity.dart';
import '../entities/financial_transaction_entity.dart';
import '../entities/user_balance_entity.dart';
import '../value_objects/requests/create_withdrawal_request.dart';
import '../value_objects/requests/payment_preference_input.dart';

abstract class BalanceRepository {
  Future<UserBalanceEntity> getUserBalance();

  Future<List<ExchangeBzcPackEntity>> getExchangeBzcPacks();

  Future<List<PaymentPreferenceEntity>> getPaymentPreferences();

  Future<void> updatePaymentPreferences(PaymentPreferenceInput input);

  Future<bool> checkPaymentPreferencesVerificationCode(String code);

  Future<void> resendPaymentPreferencesVerificationCode();

  Future<List<FinancialTransactionEntity>> getTransactions({
    required int limit,
    int page = 1,
    List<EFinancialTxStatus>? statusList,
    List<EFinancialTxType>? typesList,
    bool? isBzcAccount,
  });

  Future<EWithdrawalEligibility> checkWithdrawalEligibility();

  Future<String> generateWithdrawalPaymentSlip();

  Future<EWithdrawalResponseStatus> requestWithdrawal(
    CreateWithdrawalRequest request,
  );
}
