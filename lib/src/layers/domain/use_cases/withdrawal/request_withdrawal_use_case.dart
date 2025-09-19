import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/create_withdrawal_request.dart';

import '../../repositories/balance_repository.dart';

class RequestWithdrawalUseCase extends UseCase<void, CreateWithdrawalRequest> {
  final BalanceRepository _repository;

  const RequestWithdrawalUseCase(this._repository);

  @override
  Future<void> call(request) async {
    return await _repository.requestWithdrawal(request);
  }
}
