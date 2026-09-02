import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/balance_repository.dart';

typedef VerifyOtpParams = ({String uuid, String code});

class CheckPaymentPreferencesVerificationCodeUseCase
    extends UseCase<bool, VerifyOtpParams> {
  final BalanceRepository _repository;

  const CheckPaymentPreferencesVerificationCodeUseCase(this._repository);

  @override
  Future<bool> call(VerifyOtpParams params) {
    return _repository.checkPaymentPreferencesVerificationCode(
      uuid: params.uuid,
      code: params.code,
    );
  }
}