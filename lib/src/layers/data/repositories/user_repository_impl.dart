import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_kyc_status.dart';

import '../../domain/entities/kyc_session_entity.dart';
import '../../domain/entities/profile_completion_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/value_objects/requests/personal_infos_input.dart';
import '../../domain/value_objects/requests/update_user_profile_input.dart';
import '../data_sources/bantubeat_api_data_source.dart';
import '../models/monetization_account_model.dart';

class UserRepositoryImpl extends UserRepository {
  final BantubeatApiDataSource _apiDataSource;

  UserRepositoryImpl(this._apiDataSource);

  @override
  Future<UserEntity> getCurrentUser() => _apiDataSource.get$authUser();

  @override
  Future<void> updateUserProfile(UpdateUserProfileInput input) =>
      _apiDataSource.put$accountUser(input);

  @override
  Future<void> savePersonalInfos(PersonalInfosInput input) =>
      _apiDataSource.post$accountPersonalInfos(input);

  @override
  Future<ProfileCompletionEntity> getProfileCompletion() =>
      _apiDataSource.get$accountUserProfileCompletion();

  @override
  Future<EKycStatus> getKycStatus() => _apiDataSource.get$accountKyc();

  @override
  Future<KycSessionEntity> startKycSession({required bool isCompany}) =>
      _apiDataSource.post$accountKycSession(isCompany: isCompany);

  @override
  Future<void> deleteKyc() => _apiDataSource.delete$accountKyc();

  @override
  Future<void> generateMailOtp() {
    return _apiDataSource.post$accountUserGenerateMailOtp();
  }

  @override
  Future<String> uploadDocument({
    required String filePath,
    required String fileName,
    required String context,
  }) {
    return _apiDataSource.post$accountUpload(
      filePath: filePath,
      fileName: fileName,
      context: context,
    );
  }

  @override
  Future<void> saveMonetizationAccount({
    required String accountType,
    required String fiscalIdNumber,
    required String documentUrl,
  }) {
    return _apiDataSource.post$monetizationAccount(
      accountType: accountType,
      fiscalIdNumber: fiscalIdNumber,
      documentUrl: documentUrl,
    );
  }

  @override
  Future<List<MonetizationAccountModel>> getMonetizationAccounts() {
    return _apiDataSource.get$monetizationAccounts();
  }
}
