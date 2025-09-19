import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/balance_repository.dart';

class ResendPaymentPreferencesVerificationCodeUseCase
    extends UseCase<void, NoParms> {
  final BalanceRepository _repository;

  const ResendPaymentPreferencesVerificationCodeUseCase(this._repository);

  @override
  Future<void> call(_) async {
    return await _repository.resendPaymentPreferencesVerificationCode();
  }
}
