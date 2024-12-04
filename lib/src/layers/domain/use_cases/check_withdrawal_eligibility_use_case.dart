import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../entities/e_withdrawal_eligibility.dart';
import '../repositories/balance_repository.dart';

class CheckWithdrawalEligibilityUseCase
    implements UseCase<EWithdrawalEligibility, NoParms> {
  final BalanceRepository _repository;

  const CheckWithdrawalEligibilityUseCase(this._repository);

  @override
  Future<EWithdrawalEligibility> call(params) {
    return _repository.checkWithdrawalEligibility();
  }
}
