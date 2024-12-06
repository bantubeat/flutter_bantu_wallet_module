import '../../../core/network/my_http/my_http.dart';
import '../../domain/entities/e_withdrawal_eligibility.dart';
import '../models/currency_item_model.dart';
import '../models/currency_rates_model.dart';
import '../models/deposit_payment_link_model.dart';
import '../models/transaction_history_item_model.dart';
import '../models/user_balance_model.dart';
import '../models/exchange_bzc_pack_model.dart';
import '../models/payment_preference_model.dart';
import '../models/exchange_transaction_model.dart';
import '../models/user_model.dart';

///
/// This is a Bantubeat API Data Source, all methods are named regarding to the
/// api path to call, first is the HTTP METHOD to use GET, POST, etc
/// then the second is the uri in cameCase, so GET /public/all-currencies will
/// be  get$publicAllCurrencies.
final class BantubeatApiDataSource {
  final MyHttpClient _client;
  final MyHttpClient _cachedClient;

  const BantubeatApiDataSource({
    required MyHttpClient client,
    required MyHttpClient cachedClient,
  })  : _client = client,
        _cachedClient = cachedClient;

  Future<UserModel> get$authUser() {
    return _client.get('/auth/user').then((r) => UserModel.fromJson(r.data));
  }

  Future<UserBalanceModel> get$balance() {
    return _client
        .get('/balance')
        .then((r) => UserBalanceModel.fromJson(r.data));
  }

  Future<List<CurrencyItemModel>> get$publicAllCurrencies() {
    return _cachedClient
        .get('/public/all-currencies')
        .then((r) => r.data as List)
        .then((list) => list.map((e) => e as Map<String, dynamic>))
        .then((jsonList) => jsonList.map(CurrencyItemModel.fromJson).toList());
  }

  /// Get currencies rates
  Future<CurrencyRatesModel> get$publicCurrencies() {
    return _cachedClient
        .get('/public/currencies')
        .then((r) => CurrencyRatesModel.fromJson(r.data));
  }

  /// Exchange BZC to Fiat
  Future<ExchangeTransactionModel> post$exchangeBzcToFiat(double quantity) {
    return _client.post(
      '/exchanges/bzc_to_fiat',
      body: {'quantity': quantity},
    ).then((r) => ExchangeTransactionModel.fromJson(r.data));
  }

  /// Check if user can make a withdrawal
  /// return the httpStatus code returned by backend
  Future<EWithdrawalEligibility> get$checkWithdrawalEligibilityStatus() async {
    try {
      await _client.get('/balance/can-i-make-a-withdrawals');

      return EWithdrawalEligibility.eligible;
    } on MyHttpClientSideException catch (err) {
      final statusCode = err.statusCode;
      return EWithdrawalEligibility.values.firstWhere(
        (item) => item.httpCode == statusCode,
        orElse: () => EWithdrawalEligibility.unknownError,
      );
    } catch (_) {
      rethrow;
    }
  }

  /// Get payment preferences
  Future<List<PaymentPreferenceModel>> get$paymentPreferences() {
    return _client
        .get('/balance/payment-preferences')
        .then((r) => r.data as List)
        .then((list) => list.map((e) => e as Map<String, dynamic>))
        .then((jsonList) => jsonList.map(PaymentPreferenceModel.fromJson))
        .then((iterable) => iterable.toList());
  }

  /// Get BZC exchange packs
  Future<List<ExchangeBzcPackModel>> get$publicExchangeBzcPacks() {
    return _cachedClient
        .get('/public/exchange-bzc-packs')
        .then((r) => r.data as List)
        .then((list) => list.map((e) => e as Map<String, dynamic>))
        .then((jsonList) => jsonList.map(ExchangeBzcPackModel.fromJson))
        .then((iterable) => iterable.toList());
  }

  /// Exchange Fiat to BZC (with pack)
  Future<ExchangeTransactionModel> post$exchangeFiatToBzcWithPack({
    required double amount,
    required int exchangeBzcPackId,
  }) {
    return _client.post(
      '/exchanges/fiat_to_bzc',
      body: {'amount': amount, 'bzc_exchange_pack_id': exchangeBzcPackId},
    ).then((r) => ExchangeTransactionModel.fromJson(r.data));
  }

  /// Exchange Fiat to BZC (custom amount)
  Future<ExchangeTransactionModel> post$exchangeFiatToBzcCustom(double amount) {
    return _client
        .post('/exchanges/fiat_to_bzc', body: {'amount': amount}).then(
      (r) => ExchangeTransactionModel.fromJson(r.data),
    );
  }

  /// Get transactions with pagination
  Future<List<TransactionHistoryItemModel>> get$transactions({
    required int limit,
    int page = 1,
  }) {
    return _client
        .get('/balance/transactions?page=$page&limit=$limit')
        .then((r) => r.data['data'] as List)
        .then((list) => list.map((e) => e as Map<String, dynamic>))
        .then((jsonList) => jsonList.map(TransactionHistoryItemModel.fromJson))
        .then((iterable) => iterable.toList());
  }

  Future<DepositPaymentLinkModel> post$depositPaymentRequestPaymentLink({
    required String paymentMethod,
    required double amount,
    String? currency,
  }) {
    return _client.post(
      '/deposit-payment/request-payment-link',
      body: {
        'amount': amount,
        'payment_method': paymentMethod,
        if (currency != null) 'currency': currency,
      },
    ).then((r) => DepositPaymentLinkModel.fromJson(r.data));
  }
}
