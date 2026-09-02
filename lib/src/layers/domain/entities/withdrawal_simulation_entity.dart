import 'package:equatable/equatable.dart';

class PaymentReferenceInfoEntity extends Equatable {
  final String prefix;
  final int year;
  final String sequence;
  final String full;

  const PaymentReferenceInfoEntity({
    required this.prefix,
    required this.year,
    required this.sequence,
    required this.full,
  });

  @override
  List<Object?> get props => [prefix, year, sequence, full];
}

class SimulationPaymentPreferenceDetailEntity extends Equatable {
  final String uuid;
  final int userId;
  final String detailName;
  final String? firstName;
  final String? lastName;
  final String? detailPhone;
  final String? detailEmail;
  final String? detailIban;
  final String? detailBic;
  final String accountType;
  final String? detailCountry;
  final String? detailOperator;
  final String? detailBankName;

  const SimulationPaymentPreferenceDetailEntity({
    required this.uuid,
    required this.userId,
    required this.detailName,
    required this.accountType,
    this.firstName,
    this.lastName,
    this.detailPhone,
    this.detailEmail,
    this.detailIban,
    this.detailBic,
    this.detailCountry,
    this.detailOperator,
    this.detailBankName,
  });

  @override
  List<Object?> get props => [
        uuid,
        userId,
        detailName,
        firstName,
        lastName,
        detailPhone,
        detailEmail,
        detailIban,
        detailBic,
        accountType,
        detailCountry,
        detailOperator,
        detailBankName,
      ];
}

class SimulationPaymentPreferenceEntity extends Equatable {
  final String uuid;
  final String accountType;
  final String? label;
  final SimulationPaymentPreferenceDetailEntity? details;

  const SimulationPaymentPreferenceEntity({
    required this.uuid,
    required this.accountType,
    this.label,
    this.details,
  });

  @override
  List<Object?> get props => [uuid, accountType, label, details];
}

class WithdrawalCalculationEntity extends Equatable {
  final num grossAmount;
  final num feePlatformPct;
  final num feePlatform;
  final num feeOperatorPct;
  final num feeOperator;
  final num taxPct;
  final num tax;
  final num totalFees;
  final num netAmount;

  const WithdrawalCalculationEntity({
    required this.grossAmount,
    required this.feePlatformPct,
    required this.feePlatform,
    required this.feeOperatorPct,
    required this.feeOperator,
    required this.taxPct,
    required this.tax,
    required this.totalFees,
    required this.netAmount,
  });

  @override
  List<Object?> get props => [
        grossAmount,
        feePlatformPct,
        feePlatform,
        feeOperatorPct,
        feeOperator,
        taxPct,
        tax,
        totalFees,
        netAmount,
      ];
}

class WithdrawalLimitsEntity extends Equatable {
  final num minWithdrawal;
  final num maxDaily;
  final num balance;

  const WithdrawalLimitsEntity({
    required this.minWithdrawal,
    required this.maxDaily,
    required this.balance,
  });

  @override
  List<Object?> get props => [minWithdrawal, maxDaily, balance];
}

class WithdrawalSimulationEntity extends Equatable {
  final String paymentReference;
  final PaymentReferenceInfoEntity? paymentReferenceInfo;
  final String status;
  final String payoutType;
  final String countryCode;
  final SimulationPaymentPreferenceEntity? paymentPreference;
  final WithdrawalCalculationEntity? calculation;
  final WithdrawalLimitsEntity? limits;

  const WithdrawalSimulationEntity({
    required this.paymentReference,
    required this.status,
    required this.payoutType,
    required this.countryCode,
    this.paymentReferenceInfo,
    this.paymentPreference,
    this.calculation,
    this.limits,
  });

  @override
  List<Object?> get props => [
        paymentReference,
        paymentReferenceInfo,
        status,
        payoutType,
        countryCode,
        paymentPreference,
        calculation,
        limits,
      ];
}
