import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_kyc_status.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/bantubeat_api_data_source.dart';

class UserRepositoryImpl extends UserRepository {
  final BantubeatApiDataSource _apiDataSource;

  UserRepositoryImpl(this._apiDataSource);

  @override
  Future<UserEntity> getCurrentUser() => _apiDataSource.get$authUser();

  @override
  Future<EKycStatus> getKycStatus() => _apiDataSource.get$accountKyc();

  @override
  Future<void> generateMailOtp() {
    return _apiDataSource.post$accountUserGenerateMailOtp();
  }
}
