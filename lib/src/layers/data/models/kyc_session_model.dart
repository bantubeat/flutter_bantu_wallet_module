import '../../domain/entities/kyc_session_entity.dart';

class KycSessionModel extends KycSessionEntity {
  const KycSessionModel({
    required super.verificationUrl,
    super.uuid,
    super.diditSessionId,
    super.status,
  });

  factory KycSessionModel.fromJson(Map<String, dynamic> json) {
    final kyc = (json['kyc'] as Map?) ?? const {};
    return KycSessionModel(
      uuid: kyc['uuid'] as String?,
      diditSessionId: kyc['didit_session_id'] as String?,
      status: kyc['status'] as String?,
      verificationUrl: json['verification_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kyc': {
        if (uuid != null) 'uuid': uuid,
        if (diditSessionId != null) 'didit_session_id': diditSessionId,
        if (status != null) 'status': status,
      },
      'verification_url': verificationUrl,
    };
  }
}