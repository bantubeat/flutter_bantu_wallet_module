import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/exchange_transaction_entity.dart';
import '../../repositories/exchange_repository.dart';

class PurchaseTokenPackUseCase
    implements UseCase<ExchangeTransactionEntity, _Param> {
  final ExchangeRepository _repository;

  const PurchaseTokenPackUseCase(this._repository);

  @override
  Future<ExchangeTransactionEntity> call(params) {
    return _repository.purchaseTokenPack(tokenCount: params.tokenCount);
  }
}

typedef _Param = ({
  double tokenCount,
});
