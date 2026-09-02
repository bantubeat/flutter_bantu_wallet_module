import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/profile_completion_entity.dart';
import '../../repositories/user_repository.dart';

class GetProfileCompletionUseCase
    extends UseCase<ProfileCompletionEntity, NoParms> {
  final UserRepository _repository;

  GetProfileCompletionUseCase(this._repository);

  @override
  Future<ProfileCompletionEntity> call(params) async {
    return await _repository.getProfileCompletion();
  }
}
