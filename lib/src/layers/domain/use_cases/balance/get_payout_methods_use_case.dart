import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/payout_method_entity.dart';
import '../../repositories/balance_repository.dart';

class GetPayoutMethodsUseCase
    extends UseCase<PayoutMethodsResultEntity, NoParms> {
  final BalanceRepository _repository;

  GetPayoutMethodsUseCase(this._repository);

  @override
  Future<PayoutMethodsResultEntity> call(params) async {
    return await _repository.getPayoutMethods();
  }
}