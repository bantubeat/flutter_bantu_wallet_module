import '../../domain/entities/deposit_payment_link_entity.dart';
import '../../domain/entities/e_payment_method.dart';
import '../../domain/entities/financial_transaction_entity.dart';
import '../../domain/repositories/payment_repository.dart';

import '../data_sources/bantubeat_api_data_source.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final BantubeatApiDataSource _apiDataSource;

  PaymentRepositoryImpl(this._apiDataSource);

  @override
  Future<DepositPaymentLinkEntity> requestDepositPaymentLink({
    required EPaymentMethod paymentMethod,
    required double amount,
    String? currency,
  }) async {
    return await _apiDataSource.post$depositPaymentRequestPaymentLink(
      amount: amount,
      paymentMethod: paymentMethod.value,
      currency: currency,
    );
  }

  @override
  Future<FinancialTransactionEntity> makeDepositDirectPayment({
    required EPaymentMethod paymentMethod,
    required double amount,
    String? currency,
    String? stripeToken,
  }) async {
    return await _apiDataSource.post$depositPaymentMakeDirectPayment(
      amount: amount,
      paymentMethod: paymentMethod.value,
      currency: currency,
      stripeToken: stripeToken,
    );
  }
}
