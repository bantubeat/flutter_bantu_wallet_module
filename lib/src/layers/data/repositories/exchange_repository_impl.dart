import '../../domain/entities/exchange_transaction_entity.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../data_sources/bantubeat_api_data_source.dart';

class ExchangeRepositoryImpl extends ExchangeRepository {
  final BantubeatApiDataSource _apiDataSource;

  ExchangeRepositoryImpl(this._apiDataSource);

  @override
  Future<ExchangeTransactionEntity> exchangeBzcToFiat({
    required double quantity,
  }) {
    return _apiDataSource.post$exchangeBzcToFiat(quantity);
  }

  @override
  Future<ExchangeTransactionEntity> exchangeFiatToBzc({
    required double fiatAmountInEur,
    int? exchangeBzcPackId,
  }) {
    if (exchangeBzcPackId == null) {
      return _apiDataSource.post$exchangeFiatToBzcCustom(fiatAmountInEur);
    }

    return _apiDataSource.post$exchangeFiatToBzcWithPack(
      amount: fiatAmountInEur,
      exchangeBzcPackId: exchangeBzcPackId,
    );
  }
}
