import '../../domain/entities/withdrawal_simulation_entity.dart';

class PaymentReferenceInfoModel extends PaymentReferenceInfoEntity {
  const PaymentReferenceInfoModel({
    required super.prefix,
    required super.year,
    required super.sequence,
    required super.full,
  });

  factory PaymentReferenceInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentReferenceInfoModel(
      prefix: json['prefix'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      sequence: json['sequence']?.toString() ?? '',
      full: json['full'] as String? ?? '',
    );
  }
}

class SimulationPaymentPreferenceDetailModel
    extends SimulationPaymentPreferenceDetailEntity {
  const SimulationPaymentPreferenceDetailModel({
    required super.uuid,
    required super.userId,
    required super.detailName,
    required super.accountType,
    super.firstName,
    super.lastName,
    super.detailPhone,
    super.detailEmail,
    super.detailIban,
    super.detailBic,
    super.detailCountry,
    super.detailOperator,
    super.detailBankName,
  });

  factory SimulationPaymentPreferenceDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SimulationPaymentPreferenceDetailModel(
      uuid: json['uuid'] as String? ?? '',
      userId: json['user_id'] as int? ?? 0,
      detailName: json['detail_name'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      detailPhone: json['detail_phone'] as String?,
      detailEmail: json['detail_email'] as String?,
      detailIban: json['detail_iban'] as String?,
      detailBic: json['detail_bic'] as String?,
      accountType: json['account_type'] as String? ?? '',
      detailCountry: json['detail_country'] as String?,
      detailOperator: json['detail_operator'] as String?,
      detailBankName: json['detail_bank_name'] as String?,
    );
  }
}

class SimulationPaymentPreferenceModel
    extends SimulationPaymentPreferenceEntity {
  const SimulationPaymentPreferenceModel({
    required super.uuid,
    required super.accountType,
    super.label,
    super.details,
  });

  factory SimulationPaymentPreferenceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final detailsJson = json['details'] as Map<String, dynamic>?;
    return SimulationPaymentPreferenceModel(
      uuid: json['uuid'] as String? ?? '',
      accountType: json['account_type'] as String? ?? '',
      label: json['label'] as String?,
      details: detailsJson != null
          ? SimulationPaymentPreferenceDetailModel.fromJson(detailsJson)
          : null,
    );
  }
}

class WithdrawalCalculationModel extends WithdrawalCalculationEntity {
  const WithdrawalCalculationModel({
    required super.grossAmount,
    required super.feePlatformPct,
    required super.feePlatform,
    required super.feeOperatorPct,
    required super.feeOperator,
    required super.taxPct,
    required super.tax,
    required super.totalFees,
    required super.netAmount,
  });

  factory WithdrawalCalculationModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalCalculationModel(
      grossAmount: (json['gross_amount'] as num?) ?? 0,
      feePlatformPct: (json['fee_platform_pct'] as num?) ?? 0,
      feePlatform: (json['fee_platform'] as num?) ?? 0,
      feeOperatorPct: (json['fee_operator_pct'] as num?) ?? 0,
      feeOperator: (json['fee_operator'] as num?) ?? 0,
      taxPct: (json['tax_pct'] as num?) ?? 0,
      tax: (json['tax'] as num?) ?? 0,
      totalFees: (json['total_fees'] as num?) ?? 0,
      netAmount: (json['net_amount'] as num?) ?? 0,
    );
  }
}

class WithdrawalLimitsModel extends WithdrawalLimitsEntity {
  const WithdrawalLimitsModel({
    required super.minWithdrawal,
    required super.maxDaily,
    required super.balance,
  });

  factory WithdrawalLimitsModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalLimitsModel(
      minWithdrawal: (json['min_withdrawal'] as num?) ?? 0,
      maxDaily: (json['max_daily'] as num?) ?? 0,
      balance: (json['balance'] as num?) ?? 0,
    );
  }
}

class WithdrawalSimulationModel extends WithdrawalSimulationEntity {
  const WithdrawalSimulationModel({
    required super.paymentReference,
    required super.status,
    required super.payoutType,
    required super.countryCode,
    super.paymentReferenceInfo,
    super.paymentPreference,
    super.calculation,
    super.limits,
  });

  factory WithdrawalSimulationModel.fromJson(Map<String, dynamic> json) {
    final refInfoJson = json['payment_reference_info'] as Map<String, dynamic>?;
    final prefJson = json['payment_preference'] as Map<String, dynamic>?;
    final calcJson = json['calculation'] as Map<String, dynamic>?;
    final limitsJson = json['limits'] as Map<String, dynamic>?;

    return WithdrawalSimulationModel(
      paymentReference: json['payment_reference'] as String? ?? '',
      paymentReferenceInfo: refInfoJson != null
          ? PaymentReferenceInfoModel.fromJson(refInfoJson)
          : null,
      status: json['status'] as String? ?? '',
      payoutType: json['payout_type'] as String? ?? '',
      countryCode: json['country_code'] as String? ?? '',
      paymentPreference: prefJson != null
          ? SimulationPaymentPreferenceModel.fromJson(prefJson)
          : null,
      calculation: calcJson != null
          ? WithdrawalCalculationModel.fromJson(calcJson)
          : null,
      limits: limitsJson != null
          ? WithdrawalLimitsModel.fromJson(limitsJson)
          : null,
    );
  }
}
