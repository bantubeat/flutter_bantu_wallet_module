import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/balance_repository.dart';

typedef ResendEmailCodeParams = ({String uuid});

class ResendPaymentPreferencesEmailVerificationCodeUseCase
    extends UseCase<void, ResendEmailCodeParams> {
  final BalanceRepository _repository;

  const ResendPaymentPreferencesEmailVerificationCodeUseCase(this._repository);

  @override
  Future<void> call(ResendEmailCodeParams params) async {
    return await _repository.resendPaymentPreferencesEmailVerificationCode(
      uuid: params.uuid,
    );
  }
}