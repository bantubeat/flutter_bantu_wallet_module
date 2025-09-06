import '../entities/enums/e_kyc_status.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getCurrentUser();

  Future<EKycStatus> getKycStatus();
}
