import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/payout_configs_entity.dart';
import '../../repositories/balance_repository.dart';

class GetPayoutConfigsUseCase
    extends UseCase<PayoutConfigsEntity, NoParms> {
  final BalanceRepository _repository;

  GetPayoutConfigsUseCase(this._repository);

  @override
  Future<PayoutConfigsEntity> call(params) async {
    return await _repository.getPayoutConfigs();
  }
}
