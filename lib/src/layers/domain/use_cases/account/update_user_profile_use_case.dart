import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/user_repository.dart';
import '../../value_objects/requests/update_user_profile_input.dart';

class UpdateUserProfileUseCase extends UseCase<void, UpdateUserProfileInput> {
  final UserRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  @override
  Future<void> call(params) async {
    return await _repository.updateUserProfile(params);
  }
}
