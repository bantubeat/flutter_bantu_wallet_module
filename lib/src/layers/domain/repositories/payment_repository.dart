import '../entities/deposit_payment_link_entity.dart';
import '../entities/e_payment_method.dart';
import '../entities/financial_transaction_entity.dart';

abstract class PaymentRepository {
  Future<DepositPaymentLinkEntity> requestDepositPaymentLink({
    required EPaymentMethod paymentMethod,
    required double amount,
    String? currency,
  });

  Future<FinancialTransactionEntity> makeDepositDirectPayment({
    required EPaymentMethod paymentMethod,
    required double amount,
    String? currency,
    String? stripeToken,
  });
}
