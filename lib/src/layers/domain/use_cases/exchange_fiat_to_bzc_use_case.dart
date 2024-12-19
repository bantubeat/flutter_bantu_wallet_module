import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../entities/exchange_transaction_entity.dart';
import '../repositories/exchange_repository.dart';

class ExchangeFiatToBzcUseCase
    implements UseCase<ExchangeTransactionEntity, _Param> {
  final ExchangeRepository _repository;

  const ExchangeFiatToBzcUseCase(this._repository);

  @override
  Future<ExchangeTransactionEntity> call(params) async {
    return _repository.exchangeFiatToBzc(
      fiatAmount: params.fiatAmount,
      exchangeBzcPackId: params.exchangeBzcPackId,
    );
  }
}

typedef _Param = ({
  double fiatAmount,
  int? exchangeBzcPackId,
});
