import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../entities/exchange_bzc_pack_entity.dart';
import '../repositories/balance_repository.dart';

class GetExchangeBzcPacksUseCase
    implements UseCase<List<ExchangeBzcPackEntity>, NoParms> {
  final BalanceRepository _repository;

  const GetExchangeBzcPacksUseCase(this._repository);

  @override
  Future<List<ExchangeBzcPackEntity>> call(_) {
    return _repository.getExchangeBzcPacks();
  }
}
