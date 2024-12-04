import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUseCase extends UseCase<UserEntity, NoParms> {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<UserEntity> call(params) async {
    return await _repository.getCurrentUser();
  }
}
