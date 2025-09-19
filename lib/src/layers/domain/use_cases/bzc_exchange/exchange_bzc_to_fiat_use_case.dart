import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/exchange_transaction_entity.dart';
import '../../repositories/exchange_repository.dart';

class ExchangeBzcToFiatUseCase
    implements UseCase<ExchangeTransactionEntity, _Param> {
  final ExchangeRepository _repository;

  const ExchangeBzcToFiatUseCase(this._repository);

  @override
  Future<ExchangeTransactionEntity> call(params) async {
    return _repository.exchangeBzcToFiat(quantity: params.quantity);
  }
}

typedef _Param = ({double quantity});
