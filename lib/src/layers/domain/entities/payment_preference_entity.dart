abstract class PaymentPreferenceEntity {
  final int id;
  final String uuid;
  final int userId;
  final String? detailName;
  final String? detailPhone;
  final String? detailEmail;
  final String? detailIban;
  final String? detailBic;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String accountType;
  final String? detailCountry;
  final String? detailOperator;
  final String? detailBankName;
  final bool isVerified;
  final String? verificationCode;

  const PaymentPreferenceEntity({
    required this.id,
    required this.uuid,
    required this.userId,
    required this.accountType,
    required this.isVerified,
    this.detailName,
    this.detailPhone,
    this.detailEmail,
    this.detailIban,
    this.detailBic,
    this.createdAt,
    this.updatedAt,
    this.detailCountry,
    this.detailOperator,
    this.detailBankName,
    this.verificationCode,
  });
}
