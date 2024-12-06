import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/deposit_payment_link_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/e_payment_method.dart';

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
    required double amount,
    int? exchangeBzcPackId,
  }) {
    if (exchangeBzcPackId == null) {
      return _apiDataSource.post$exchangeFiatToBzcCustom(amount);
    }

    return _apiDataSource.post$exchangeFiatToBzcWithPack(
      amount: amount,
      exchangeBzcPackId: exchangeBzcPackId,
    );
  }

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
}
