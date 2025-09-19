import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/user_repository.dart';

class SendWithdrawalMailOtpUseCase extends UseCase<void, NoParms> {
  final UserRepository _repository;

  const SendWithdrawalMailOtpUseCase(this._repository);

  @override
  Future<void> call(_) async {
    return await _repository.generateMailOtp();
  }
}
