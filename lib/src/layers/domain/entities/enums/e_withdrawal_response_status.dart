enum EWithdrawalResponseStatus {
  successfullyCreated(201),
  badOrExpiredPaymentSlip(400),
  kycNotValidated(403),
  paymentPreferenceNotFound(404),
  insufficientBalance(406),
  requestConflict(409),
  badOrExpiredOTPCode(412),
  invalidRequestPeriod(425),
  unknownError(0);

  final int httpCode;
  const EWithdrawalResponseStatus(this.httpCode);

  factory EWithdrawalResponseStatus.fromHttpCode(int code) {
    return EWithdrawalResponseStatus.values.firstWhere(
      (e) => e.httpCode == code,
      orElse: () => EWithdrawalResponseStatus.unknownError,
    );
  }
}

extension WithdrawalRequestStatusExtension on EWithdrawalResponseStatus {
  String get englishDescription {
    switch (this) {
      case EWithdrawalResponseStatus.successfullyCreated:
        return 'Withdrawal request created successfully';
      case EWithdrawalResponseStatus.badOrExpiredPaymentSlip:
        return 'Bad or expired payment slip';
      case EWithdrawalResponseStatus.kycNotValidated:
        return 'KYC not validated';
      case EWithdrawalResponseStatus.paymentPreferenceNotFound:
        return 'Payment preference not found';
      case EWithdrawalResponseStatus.insufficientBalance:
        return 'Insufficient balance amount';
      case EWithdrawalResponseStatus.requestConflict:
        return 'Already made a withdrawal this month or pending one exists';
      case EWithdrawalResponseStatus.badOrExpiredOTPCode:
        return 'Bad or expired OTP code';
      case EWithdrawalResponseStatus.invalidRequestPeriod:
        return 'Withdraw request must be between the 25th and 31th of month';
      case EWithdrawalResponseStatus.unknownError:
        return 'An unknown error occurred';
    }
  }
}
