import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/token_price_entity.dart';
import '../../repositories/public_repository.dart';

class GetTokenPricesUseCase implements UseCase<TokenPriceEntity, NoParms> {
  final PublicRepository _repository;

  const GetTokenPricesUseCase(this._repository);

  @override
  Future<TokenPriceEntity> call(NoParms params) {
    return _repository.getTokenPacks();
  }
}
