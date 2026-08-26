import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/balance_repository.dart';
import 'check_payment_preferences_verification_code_use_case.dart'
    show VerifyOtpParams;

class CheckPaymentPreferencesEmailVerificationCodeUseCase
    extends UseCase<bool, VerifyOtpParams> {
  final BalanceRepository _repository;

  const CheckPaymentPreferencesEmailVerificationCodeUseCase(this._repository);

  @override
  Future<bool> call(VerifyOtpParams params) {
    return _repository.checkPaymentPreferencesEmailVerificationCode(
      uuid: params.uuid,
      code: params.code,
    );
  }
}