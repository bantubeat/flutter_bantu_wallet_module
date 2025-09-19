import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/balance_repository.dart';

class GenerateWithdrawalPaymentSlipUseCase extends UseCase<String, NoParms> {
  final BalanceRepository _repository;

  const GenerateWithdrawalPaymentSlipUseCase(this._repository);

  @override
  Future<String> call(NoParms params) async {
    return await _repository.generateWithdrawalPaymentSlip();
  }
}
