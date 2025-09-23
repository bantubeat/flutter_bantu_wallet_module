import 'package:image_picker/image_picker.dart' show XFile;
import 'package:country_code_picker/country_code_picker.dart' show CountryCode;
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/payment_preference_input.dart';

typedef AccountHolderInfo = ({
  String firstName,
  String lastName,
  DateTime birthdate,
  String street,
  String city,
  String postalCode,
});

typedef MobilePaymentAccountInfo = ({
  CountryCode paymentCountry,
  String mobileOperator,
  String mobileAccountNumber,
  XFile? otherDocument,
});

typedef BankPaymentAccountInfo = ({
  String bankName,
  String bankAccountNumber,
  String bankSwiftCode,
  XFile? bankDocument,
});

class PaymentAccountFormDataType {
  final EAccountType accountType;
  final AccountHolderInfo accountHolder;
  final MobilePaymentAccountInfo? mobileAccountInfo;
  final BankPaymentAccountInfo? bankAccountInfo;

  PaymentAccountFormDataType.mobilePayment({
    required CountryCode paymentCountry,
    required String mobileOperator,
    required String mobileAccountNumber,
    required this.accountHolder,
    required XFile? otherDocument,
  })  : accountType = EAccountType.mobile,
        mobileAccountInfo = (
          paymentCountry: paymentCountry,
          mobileOperator: mobileOperator,
          mobileAccountNumber: mobileAccountNumber,
          otherDocument: otherDocument,
        ),
        bankAccountInfo = null;

  PaymentAccountFormDataType.bankPayment({
    required String bankName,
    required String bankAccountNumber,
    required String bankSwiftCode,
    required this.accountHolder,
    required XFile? bankDocument,
  })  : accountType = EAccountType.bankTransfer,
        mobileAccountInfo = null,
        bankAccountInfo = (
          bankName: bankName,
          bankAccountNumber: bankAccountNumber,
          bankSwiftCode: bankSwiftCode,
          bankDocument: bankDocument,
        );

  PaymentPreferenceInput? toPaymentPreferenceInput() {
    final mobileData = mobileAccountInfo;
    final bankData = bankAccountInfo;
    if (mobileData != null) {
      return PaymentPreferenceInput(
        accountType: accountType,
        detailPhone: mobileData.mobileAccountNumber,
        detailCountry: mobileData.paymentCountry.code,
        detailOperator: mobileData.mobileOperator,
        detailName: '${accountHolder.firstName} ${accountHolder.lastName}',
      );
    }

    if (bankData != null) {
      return PaymentPreferenceInput(
        accountType: accountType,
        detailBankName: bankData.bankName,
        detailBic: bankData.bankSwiftCode,
        detailIban: bankData.bankAccountNumber,
        detailName: '${accountHolder.firstName} ${accountHolder.lastName}',
      );
    }

    return null;
  }
}
