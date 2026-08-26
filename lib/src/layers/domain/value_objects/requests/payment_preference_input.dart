import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:intl/intl.dart';

class PaymentPreferenceInput {
  final EAccountType accountType;
  final String? detailBankName;
  final String? detailBic;
  final String? detailIban;
  final String? detailPhone;
  final String? detailCountry;
  final String? detailOperator;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? city;
  final String? postalCode;
  final String? street;

  const PaymentPreferenceInput({
    required this.accountType,
    this.detailBankName,
    this.detailBic,
    this.detailIban,
    this.detailPhone,
    this.detailCountry,
    this.detailOperator,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.city,
    this.postalCode,
    this.street,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_type': accountType.value,
      if (detailBankName != null) 'detail_bank_name': detailBankName,
      if (detailBic != null) 'detail_bic': detailBic,
      if (detailIban != null) 'detail_iban': detailIban,
      if (detailPhone != null) 'detail_phone': detailPhone,
      if (detailCountry != null) 'detail_country': detailCountry,
      if (detailOperator != null)
        'detail_operator': detailOperator?.toUpperCase(),
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (birthDate != null)
        'birth_date': DateFormat('yyyy-MM-dd').format(birthDate!),
      if (city != null) 'city': city,
      if (postalCode != null) 'postal_code': postalCode,
      if (street != null) 'street': street,
    };
  }
}
