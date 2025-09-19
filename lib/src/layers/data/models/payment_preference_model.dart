import '../../domain/entities/enums/e_account_type.dart';
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
      id: json['id'],
      uuid: json['uuid'],
      userId: json['user_id'],
      detailName: json['detail_name'],
      detailPhone: json['detail_phone'],
      detailEmail: json['detail_email'],
      detailIban: json['detail_iban'],
      detailBic: json['detail_bic'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      accountType: EAccountType.fromString(json['account_type']),
      detailCountry: json['detail_country'],
      detailOperator: json['detail_operator'],
      detailBankName: json['detail_bank_name'],
      isVerified: int.tryParse(json['is_verified'] ?? '') == 1,
      verificationCode: json['verification_code'],
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
      'account_type': accountType.value,
      'detail_country': detailCountry,
      'detail_operator': detailOperator,
      'detail_bank_name': detailBankName,
      'is_verified': isVerified ? 1 : 0,
      'verification_code': verificationCode,
    };
  }
}
