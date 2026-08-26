import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/user_repository.dart';
import '../../value_objects/requests/personal_infos_input.dart';

class SavePersonalInfosUseCase extends UseCase<void, PersonalInfosInput> {
  final UserRepository _repository;

  SavePersonalInfosUseCase(this._repository);

  @override
  Future<void> call(params) async {
    return await _repository.savePersonalInfos(params);
  }
}
