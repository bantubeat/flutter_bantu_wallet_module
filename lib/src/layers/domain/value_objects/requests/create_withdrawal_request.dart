import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';

class CreateWithdrawalRequest {
  final String otpCode;
  final num amount;
  final String paymentSlip;
  final String financialAccountId;
  final String? paymentReference;
  final PaymentPreferenceEntity paymentPreference;

  const CreateWithdrawalRequest({
    required this.otpCode,
    required this.amount,
    required this.paymentSlip,
    required this.paymentPreference,
    required this.financialAccountId,
    this.paymentReference,
  });

  CreateWithdrawalRequest copyWith({
    String? otpCode,
    num? amount,
    String? paymentSlip,
    String? financialAccountId,
    String? paymentReference,
    PaymentPreferenceEntity? paymentPreference,
  }) {
    return CreateWithdrawalRequest(
      otpCode: otpCode ?? this.otpCode,
      amount: amount ?? this.amount,
      paymentSlip: paymentSlip ?? this.paymentSlip,
      paymentPreference: paymentPreference ?? this.paymentPreference,
      financialAccountId: financialAccountId ?? this.financialAccountId,
      paymentReference: paymentReference ?? this.paymentReference,
    );
  }

  Map<String, dynamic> toHttpBody() {
    return {
      'otp_code': otpCode,
      'amount': amount,
      'payment_slip': paymentSlip,
      'payment_preference_uuid': paymentPreference.uuid,
      if (paymentReference != null) 'payment_reference': paymentReference,
    };
  }
}
