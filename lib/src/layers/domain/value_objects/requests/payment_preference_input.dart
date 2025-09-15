import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/add_payment_account/ui_model/ui_model.dart';

class PaymentPreferenceInput {
  final EAccountType accountType;
  final String? detailBankName;
  final String? detailBic;
  final String? detailIban;
  final String? detailName;
  final String? detailPhone;
  final String? detailCountry;
  final String? detailOperator;
  final String? detailEmail;

  const PaymentPreferenceInput({
    required this.accountType,
    this.detailBankName,
    this.detailBic,
    this.detailIban,
    this.detailName,
    this.detailPhone,
    this.detailCountry,
    this.detailOperator,
    this.detailEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_type': switch (accountType) {
        EAccountType.mobile => 'Mobile',
        EAccountType.bank => 'BankTransfer',
        // default => 'Paypal'
      },
      if (detailBankName != null) 'detail_bank_name': detailBankName,
      if (detailBic != null) 'detail_bic': detailBic,
      if (detailIban != null) 'detail_iban': detailIban,
      if (detailName != null) 'detail_name': detailName,
      if (detailPhone != null) 'detail_phone': detailPhone,
      if (detailCountry != null) 'detail_country': detailCountry,
      if (detailOperator != null) 'detail_operator': detailOperator,
      if (detailEmail != null) 'detail_email': detailEmail,
    };
  }
}
