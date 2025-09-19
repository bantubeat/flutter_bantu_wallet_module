import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/balance_repository.dart';

class CheckPaymentPreferencesVerificationCodeUseCase
    extends UseCase<bool, String> {
  final BalanceRepository _repository;

  const CheckPaymentPreferencesVerificationCodeUseCase(this._repository);

  @override
  Future<bool> call(String code) async {
    return await _repository.checkPaymentPreferencesVerificationCode(code);
  }
}
