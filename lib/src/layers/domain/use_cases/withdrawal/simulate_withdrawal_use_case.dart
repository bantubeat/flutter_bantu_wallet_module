import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/withdrawal_simulation_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/repositories/balance_repository.dart';

class SimulateWithdrawalParams {
  final num amount;
  final String paymentPreferenceUuid;

  const SimulateWithdrawalParams({
    required this.amount,
    required this.paymentPreferenceUuid,
  });
}

class SimulateWithdrawalUseCase
    extends UseCase<WithdrawalSimulationEntity, SimulateWithdrawalParams> {
  final BalanceRepository _repository;

  SimulateWithdrawalUseCase(this._repository);

  @override
  Future<WithdrawalSimulationEntity> call(SimulateWithdrawalParams params) {
    return _repository.simulateWithdrawal(
      amount: params.amount,
      paymentPreferenceUuid: params.paymentPreferenceUuid,
    );
  }
}
