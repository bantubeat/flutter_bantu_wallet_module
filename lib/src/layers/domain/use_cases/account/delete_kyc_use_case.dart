import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/user_repository.dart';

class DeleteKycUseCase extends UseCase<void, NoParms> {
  final UserRepository _repository;

  DeleteKycUseCase(this._repository);

  @override
  Future<void> call(params) async {
    return await _repository.deleteKyc();
  }
}