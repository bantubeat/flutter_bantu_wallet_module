import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/enums/e_kyc_status.dart';
import '../../repositories/user_repository.dart';

class GetKycStatusUseCase extends UseCase<EKycStatus, NoParms> {
  final UserRepository _repository;

  GetKycStatusUseCase(this._repository);

  @override
  Future<EKycStatus> call(params) async {
    return await _repository.getKycStatus();
  }
}
