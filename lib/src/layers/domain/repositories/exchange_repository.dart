import '../entities/deposit_payment_link_entity.dart';
import '../entities/e_payment_method.dart';
import '../entities/exchange_transaction_entity.dart';

abstract class ExchangeRepository {
  Future<ExchangeTransactionEntity> exchangeBzcToFiat({
    required double quantity,
  });

  Future<ExchangeTransactionEntity> exchangeFiatToBzc({
    required double amount,
    int? exchangeBzcPackId,
  });

  Future<DepositPaymentLinkEntity> requestDepositPaymentLink({
    required EPaymentMethod paymentMethod,
    required double amount,
    String? currency,
  });
}
