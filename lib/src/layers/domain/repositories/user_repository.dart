import 'package:flutter_bantu_wallet_module/src/layers/data/models/monetization_account_model.dart';

import '../entities/enums/e_kyc_status.dart';
import '../entities/kyc_session_entity.dart';
import '../entities/profile_completion_entity.dart';
import '../entities/user_entity.dart';
import '../value_objects/requests/personal_infos_input.dart';
import '../value_objects/requests/update_user_profile_input.dart';

abstract class UserRepository {
  Future<UserEntity> getCurrentUser();

  /// Updates the current user's profile.
  Future<void> updateUserProfile(UpdateUserProfileInput input);

  /// Saves the current user's personal informations.
  Future<void> savePersonalInfos(PersonalInfosInput input);

  /// Checks if the current user's profile is complete.
  Future<ProfileCompletionEntity> getProfileCompletion();

  Future<EKycStatus> getKycStatus();

  Future<KycSessionEntity> startKycSession({required bool isCompany});

  Future<void> deleteKyc();

  Future<void> generateMailOtp();

  /// Uploads a document file and returns its public URL.
  Future<String> uploadDocument({
    required String filePath,
    required String fileName,
    required String context,
  });

  /// Creates or updates the monetization account of the given [accountType].
  Future<void> saveMonetizationAccount({
    required String accountType,
    required String fiscalIdNumber,
    required String documentUrl,
  });

  /// Returns the current user's monetization accounts (empty if none).
  Future<List<MonetizationAccountModel>> getMonetizationAccounts();
}
