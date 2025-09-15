import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';

class CreateWithdrawalRequest {
  final String otpCode;
  final num amount;
  final String paymentSlip;
  final String financialAccountId;
  final PaymentPreferenceEntity paymentPreference;

  const CreateWithdrawalRequest({
    required this.otpCode,
    required this.amount,
    required this.paymentSlip,
    required this.paymentPreference,
    required this.financialAccountId,
  });

  Map<String, dynamic> toHttpBody() {
    return {
      'otp_code': otpCode,
      'amount': amount,
      'payment_slip': paymentSlip,
      'payment_preference_uuid': paymentPreference.uuid,
    };
  }
}
