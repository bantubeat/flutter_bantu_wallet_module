import 'package:equatable/equatable.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/balance_repository.dart';

class ConvertDiamondsParams extends Equatable {
  final double diamondAmount;

  const ConvertDiamondsParams(this.diamondAmount);

  @override
  List<Object?> get props => [diamondAmount];
}

class ConvertDiamondsUseCase implements UseCase<void, ConvertDiamondsParams> {
  final BalanceRepository _repository;

  const ConvertDiamondsUseCase(this._repository);

  @override
  Future<void> call(ConvertDiamondsParams params) {
    return _repository.convertDiamonds(params.diamondAmount);
  }
}
