import 'package:country_code_picker/country_code_picker.dart' show CountryCode;
import 'package:image_picker/image_picker.dart' show XFile;

enum EAccountType { mobile, bank }

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
  AccountHolderInfo accountHolder;
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
  })  : accountType = EAccountType.bank,
        mobileAccountInfo = null,
        bankAccountInfo = (
          bankName: bankName,
          bankAccountNumber: bankAccountNumber,
          bankSwiftCode: bankSwiftCode,
          bankDocument: bankDocument,
        );
}
