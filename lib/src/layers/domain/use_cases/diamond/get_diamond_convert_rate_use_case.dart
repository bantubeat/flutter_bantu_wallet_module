import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/diamond_convert_rate_entity.dart';
import '../../repositories/public_repository.dart';

class GetDiamondConvertRateUseCase
    implements UseCase<DiamondConvertRateEntity, NoParms> {
  final PublicRepository _repository;

  const GetDiamondConvertRateUseCase(this._repository);

  @override
  Future<DiamondConvertRateEntity> call(NoParms params) {
    return _repository.getDiamondConvertRate();
  }
}
