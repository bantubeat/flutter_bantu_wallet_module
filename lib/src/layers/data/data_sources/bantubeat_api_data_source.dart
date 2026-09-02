import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:flutter_bantu_wallet_module/src/layers/data/models/eligible_country.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_kyc_status.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_withdrawal_response_status.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/profile_completion_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/create_withdrawal_request.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/payment_preference_input.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/personal_infos_input.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/update_user_profile_input.dart';

import '../../../core/network/my_http/my_http.dart';
import '../../domain/entities/enums/e_withdrawal_eligibility.dart';
import '../../domain/entities/financial_transaction_entity.dart';
import '../models/currency_item_model.dart';
import '../models/currency_rates_model.dart';
import '../models/deposit_payment_link_model.dart';
import '../models/diamond_convert_rate_model.dart';
import '../models/financial_transaction_model.dart';
import '../models/user_balance_model.dart';
import '../models/exchange_bzc_pack_model.dart';
import '../models/payment_preference_model.dart';
import '../models/payout_method_model.dart';
import '../models/payout_configs_model.dart';
import '../models/exchange_transaction_model.dart';
import '../models/withdrawal_simulation_model.dart';
import '../models/kyc_session_model.dart';
import '../models/monetization_account_model.dart';
import '../models/token_price_model.dart';
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

  String _mapToQueryParams(Map<String, dynamic> params) {
    return params.entries.map((e) {
      return '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}';
    }).join('&');
  }

  Future<UserModel> get$authUser() {
    return _client.get('/auth/user').then((r) => UserModel.fromJson(r.data));
  }

  /// Check if the current user's profile is complete.
  Future<ProfileCompletionEntity> get$accountUserProfileCompletion() {
    return _client
        .get('/account/user/profile-completion')
        .then((r) => ProfileCompletionEntity.fromJson(r.data));
  }

  /// Update the current user's profile.
  Future<void> put$accountUser(UpdateUserProfileInput input) {
    return _client.post('/account/user', body: input.toJson()).then((r) => {});
  }

  /// Save the current user's personal informations.
  Future<void> post$accountPersonalInfos(PersonalInfosInput input) {
    return _client
        .post('/account/user/personal-info', body: input.toJson())
        .then((r) => {});
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

  Future<List<EligibleCountry>?> get$checkMonetizationEligibleCountries([
    String? countryCode,
  ]) {
    final query = countryCode == null ? '' : '?country_code=$countryCode';
    return _client
        .get(
      '/public/monetization-eligible-countries$query',
    )
        .then((res) {
      final data = res.data;
      if (data is List) {
        return data.map((e) => EligibleCountry.fromJson(e)).toList();
      } else {
        return null;
      }
      // return Balance.fromJson(res.data);
    });
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

  /// Post payment preferences
  Future<PaymentPreferenceModel> post$paymentPreferences(
    PaymentPreferenceInput input,
  ) {
    return _client
        .post('/balance/payment-preferences', body: input.toJson())
        .then((r) => PaymentPreferenceModel.fromJson(r.data));
  }

  /// Post payment preferences code validation
  Future<void> post$paymentPreferencesVerifyOtp({
    required String uuid,
    required String code,
  }) {
    return _client.post(
      '/balance/payment-preferences/verify-otp',
      body: {'uuid': uuid, 'code': code},
    ).then((r) {});
  }

  /// Post payment preferences code resend
  Future<void> post$paymentPreferencesResendCode() {
    return _client
        .post('balance/payment-preferences/resend-code')
        .then((r) => {});
  }

  /// Post payment preferences email code validation
  Future<void> post$paymentPreferencesVerifyEmailCode({
    required String uuid,
    required String code,
  }) {
    return _client.post(
      '/balance/payment-preferences/verify-email-code',
      body: {'uuid': uuid, 'code': code},
    ).then((r) {});
  }

  /// Post payment preferences email code resend
  Future<void> post$paymentPreferencesResendEmailCode({
    required String uuid,
  }) {
    return _client.post(
      'balance/payment-preferences/resend-email-code',
      body: {'uuid': uuid},
    ).then((r) => {});
  }

  /// Post payment preferences code resend
  Future<String> get$publicGenerateWithdrawalPaymentSlip() {
    return _client
        .get('public/generate-withdrawal-payment-slip')
        .then((r) => r.data['data']);
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

  /// Get token packs for the current user's monetary zone
  Future<TokenPriceModel> get$tokenPacks() {
    return _client
        .get('/token-packs')
        .then((r) => TokenPriceModel.fromJson(r.data));
  }

  /// Get the diamond conversion rate for the current user's monetary zone
  Future<DiamondConvertRateModel> get$diamondConvertRate() {
    return _client
        .get('/diamond/convert-rate')
        .then((r) => DiamondConvertRateModel.fromJson(r.data));
  }

  /// Convert diamonds to stars for the current user
  Future<void> post$diamondConvert(double diamondAmount) {
    return _client.post(
      '/diamond/convert',
      body: {'diamond_amount': diamondAmount},
    ).then((r) => {});
  }

  /// Purchase a token pack for the current user
  Future<ExchangeTransactionModel> post$tokenPackPurchase(double tokenCount) {
    return _client.post(
      '/token-packs/purchase',
      body: {'token_count': tokenCount.toInt().toString()},
    ).then((r) => ExchangeTransactionModel.fromJson(r.data));
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
  Future<List<FinancialTransactionModel>> get$transactions({
    required int limit,
    int page = 1,
    List<EFinancialTxStatus>? statusList,
    List<EFinancialTxType>? typesList,
    AccountType? accountType,
    String? keyword,
  }) {
    String queryString = _mapToQueryParams({
      'limit': limit,
      'page': page,
      if (accountType != null) 'account_type': accountType.name,
      if (keyword != null) 'keyword': keyword,
      if (statusList != null)
        for (final status in statusList) 'financial_tx_status[]': status.value,
      if (typesList != null)
        for (final type in typesList) 'financial_tx_type[]': type.value,
    });
    return _client
        .get('/balance/transactions?$queryString')
        .then((r) => r.data['data'] as List)
        .then((list) => list.map((e) => e as Map<String, dynamic>))
        .then((jsonList) => jsonList.map(FinancialTransactionModel.fromJson))
        .then((iterable) => iterable.toList());
  }

  Future<PayoutMethodsResultModel> get$balancePayoutMethods() {
    return _client
        .get('/balance/payout-methods')
        .then((r) => PayoutMethodsResultModel.fromJson(r.data));
  }

  Future<PayoutConfigsModel> get$payoutConfigs() {
    return _client
        .get('/balance/payout-configs')
        .then((r) => PayoutConfigsModel.fromJson(r.data));
  }

  Future<DepositPaymentLinkModel> post$depositPaymentRequestPaymentLink({
    required String paymentMethod,
    required double amount,
    String? currency,
  }) {
    return _client.post(
      '/deposit-payment/request-payment-link',
      body: {
        'amount': amount.toString(),
        'payment_method': paymentMethod,
        if (currency != null) 'currency': currency,
      },
    ).then((r) => DepositPaymentLinkModel.fromJson(r.data));
  }

  Future<FinancialTransactionModel> post$depositPaymentMakeDirectPayment({
    required String paymentMethod,
    required double amount,
    String? currency,
    String? stripeToken,
  }) {
    return _client.post(
      '/deposit-payment/make-direct-payment',
      body: {
        'amount': amount.toString(),
        'payment_method': paymentMethod,
        if (currency != null) 'currency': currency,
        'meta': {
          if (stripeToken != null) 'stripe_token': stripeToken,
        },
      },
    ).then((r) => FinancialTransactionModel.fromJson(r.data));
  }

  Future<EKycStatus> get$accountKyc() async {
    try {
      final response = await _client.get('/account/kyc');
      final status = response.data['status'];
      if (status == null || status is! String) return EKycStatus.unknow;
      switch (status.toUpperCase()) {
        case 'PENDING':
          return EKycStatus.pending;
        case 'SUCCESS':
          return EKycStatus.success;
        case 'FAILED':
          return EKycStatus.failed;
        default:
          return EKycStatus.unknow;
      }
    } catch (err) {
      if (err is MyHttpClientSideException && err.statusCode == 404) {
        return EKycStatus.notSubmitted;
      }
      rethrow;
    }
  }

  Future<void> post$accountUserGenerateMailOtp() {
    return _client.post('/account/user/generate-mail-otp').then((r) => {});
  }

  Future<KycSessionModel> post$accountKycSession({required bool isCompany}) {
    return _client.post(
      '/account/kyc/session',
      body: {'is_company': isCompany ? 1 : 0},
    ).then((r) => KycSessionModel.fromJson(r.data));
  }

  Future<void> delete$accountKyc() {
    return _client.delete('/account/kyc').then((r) => {});
  }

  /// Upload a file as multipart/form-data. The [context] value determines the
  /// server storage folder (e.g. 'monetization_document').
  /// Returns the public URL of the uploaded file.
  Future<String> post$accountUpload({
    required String filePath,
    required String fileName,
    required String context,
  }) async {
    final multipartFile = await MultipartFile.fromFile(
      filePath,
      filename: fileName,
    );
    final formData = FormData.fromMap({
      'context': context,
      'file': multipartFile,
    });
    final data = await _client
        .post('/account/upload', body: formData)
        .then((r) => r.data);
    if (data is String && data.isNotEmpty) return data;
    if (data is Map) {
      final nested = data['data'];
      final dynamic url = data['url'] ??
          data['document_url'] ??
          data['path'] ??
          (nested is Map
              ? nested['url'] ?? nested['document_url'] ?? nested['path']
              : null);
      if (url is String && url.isNotEmpty) return url;
    }
    throw const MyHttpBadRequestException(
      message: 'The upload response does not contain a file URL',
    );
  }

  /// Create or update the monetization account for the given [accountType].
  /// If an account of the same type already exists it is updated and its
  /// status goes back to pending.
  Future<void> post$monetizationAccount({
    required String accountType,
    required String fiscalIdNumber,
    required String documentUrl,
  }) {
    return _client.post(
      '/account/monetization-accounts',
      body: {
        'account_type': accountType,
        'fiscal_id_number': fiscalIdNumber,
        'document_url': documentUrl,
      },
    ).then((r) => {});
  }

  /// Get the current user's monetization accounts. Returns an empty list when
  /// none exists (404).
  Future<List<MonetizationAccountModel>> get$monetizationAccounts() async {
    try {
      final data = await _client
          .get('/account/monetization-accounts')
          .then((r) => r.data);
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(MonetizationAccountModel.fromJson)
          .toList();
    } on MyHttpNotFoundException {
      return [];
    }
  }

  Future<EWithdrawalResponseStatus> post$balanceWithdrawals(
    CreateWithdrawalRequest request,
  ) {
    return _client
        .post('/balance/withdrawals', body: request.toHttpBody())
        .then((r) => EWithdrawalResponseStatus.successfullyCreated)
        .catchError((err) {
      if (err is MyHttpClientSideException) {
        return EWithdrawalResponseStatus.fromHttpCode(err.statusCode);
      }
      throw err;
    });
  }

  Future<WithdrawalSimulationModel> post$balanceWithdrawalsSimulate({
    required num amount,
    required String paymentPreferenceUuid,
  }) {
    return _client
        .post(
      '/balance/withdrawals/simulate',
      body: {
        'amount': amount,
        'payment_preference_uuid': paymentPreferenceUuid,
      },
    )
        .then((r) => WithdrawalSimulationModel.fromJson(r.data));
  }
}
