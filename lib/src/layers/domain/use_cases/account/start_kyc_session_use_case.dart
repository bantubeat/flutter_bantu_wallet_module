import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/kyc_session_entity.dart';
import '../../repositories/user_repository.dart';

class StartKycSessionUseCase
    extends UseCase<KycSessionEntity, StartKycSessionParams> {
  final UserRepository _repository;

  StartKycSessionUseCase(this._repository);

  @override
  Future<KycSessionEntity> call(params) async {
    return await _repository.startKycSession(isCompany: params.isCompany);
  }
}

class StartKycSessionParams {
  final bool isCompany;

  const StartKycSessionParams({required this.isCompany});
}