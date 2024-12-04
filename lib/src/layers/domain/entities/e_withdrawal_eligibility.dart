enum EWithdrawalEligibility {
  eligible(204),
  kycNotValidated(403),
  alreadyMadeWithdrawal(406),
  pendingWithdrawal(409),
  invalidRequestPeriod(425),
  unknownError(0);

  final int httpCode;
  const EWithdrawalEligibility(this.httpCode);
}

extension WithdrawalRequestStatusExtension on EWithdrawalEligibility {
  String get englishDescription {
    switch (this) {
      case EWithdrawalEligibility.eligible:
        return 'Can make a withdrawal';
      case EWithdrawalEligibility.kycNotValidated:
        return 'KYC not validated';
      case EWithdrawalEligibility.alreadyMadeWithdrawal:
        return 'Already made a withdrawal this month';
      case EWithdrawalEligibility.pendingWithdrawal:
        return 'Already have a pending withdrawal';
      case EWithdrawalEligibility.invalidRequestPeriod:
        return 'Withdraw request must be between the 25th and 31th of month';
      case EWithdrawalEligibility.unknownError:
        return 'An unknown error occurred';
    }
  }
}
