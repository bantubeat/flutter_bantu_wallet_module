import 'enums/e_account_type.dart';

abstract class PaymentPreferenceEntity {
  final String uuid;
  final int userId;
  final String? detailName;
  final String? detailPhone;
  final String? detailEmail;
  final String? detailIban;
  final String? detailBic;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final EAccountType accountType;
  final String? detailCountry;
  final String? detailOperator;
  final String? detailBankName;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? street;
  final String? city;
  final String? postalCode;
  final bool isVerified;
  final String? verificationCode;

  const PaymentPreferenceEntity({
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
    this.firstName,
    this.lastName,
    this.birthDate,
    this.street,
    this.city,
    this.postalCode,
    this.verificationCode,
  });
}
