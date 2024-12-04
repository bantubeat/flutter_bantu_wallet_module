import '../../domain/entities/payment_preference_entity.dart';

class PaymentPreferenceModel extends PaymentPreferenceEntity {
  const PaymentPreferenceModel({
    required super.id,
    required super.uuid,
    required super.userId,
    required super.accountType,
    required super.isVerified,
    super.detailCountry,
    super.detailOperator,
    super.detailBankName,
    super.detailName,
    super.detailPhone,
    super.detailEmail,
    super.detailIban,
    super.detailBic,
    super.verificationCode,
    super.createdAt,
    super.updatedAt,
  });

  factory PaymentPreferenceModel.fromJson(Map<String, dynamic> json) {
    return PaymentPreferenceModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      userId: json['user_id'] as int,
      detailName: json['detail_name'] as String?,
      detailPhone: json['detail_phone'] as String?,
      detailEmail: json['detail_email'] as String?,
      detailIban: json['detail_iban'] as String?,
      detailBic: json['detail_bic'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      accountType: json['account_type'] as String,
      detailCountry: json['detail_country'] as String?,
      detailOperator: json['detail_operator'] as String?,
      detailBankName: json['detail_bank_name'] as String?,
      isVerified: int.tryParse(json['is_verified'] ?? '') == 1,
      verificationCode: json['verification_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'user_id': userId,
      'detail_name': detailName,
      'detail_phone': detailPhone,
      'detail_email': detailEmail,
      'detail_iban': detailIban,
      'detail_bic': detailBic,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'account_type': accountType,
      'detail_country': detailCountry,
      'detail_operator': detailOperator,
      'detail_bank_name': detailBankName,
      'is_verified': isVerified ? 1 : 0,
      'verification_code': verificationCode,
    };
  }
}
