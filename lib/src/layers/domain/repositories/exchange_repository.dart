import '../entities/exchange_transaction_entity.dart';

abstract class ExchangeRepository {
  Future<ExchangeTransactionEntity> exchangeBzcToFiat({
    required double quantity,
  });

  Future<ExchangeTransactionEntity> exchangeFiatToBzc({
    required double fiatAmountInEur,
    int? exchangeBzcPackId,
  });
}
