class EligibleCountry {
  final int id;
  final String countryCode;
  final String currency;
  final bool isMonetisationActive;
  final bool isPayoutActive;
  final String kycLevel;
  final bool kycAllFieldsRequired;
  final double payoutMinThreshold;
  final double payoutDailyLimit;
  final double payoutWeeklyLimit;
  final double payoutMonthlyLimit;
  final String pspPayin;
  final String pspPayout;
  final String? complianceNotes;
  final double fxSpread;
  final String roundingRule;
  final int quoteTtlMinutes;
  final String displayCurrency;
  final bool showBzcAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  EligibleCountry({
    required this.id,
    required this.countryCode,
    required this.currency,
    required this.isMonetisationActive,
    required this.isPayoutActive,
    required this.kycLevel,
    required this.kycAllFieldsRequired,
    required this.payoutMinThreshold,
    required this.payoutDailyLimit,
    required this.payoutWeeklyLimit,
    required this.payoutMonthlyLimit,
    required this.pspPayin,
    required this.pspPayout,
    required this.fxSpread,
    required this.roundingRule,
    required this.quoteTtlMinutes,
    required this.displayCurrency,
    required this.showBzcAmount,
    required this.createdAt,
    required this.updatedAt,
    this.complianceNotes,
  });

  factory EligibleCountry.fromJson(Map<String, dynamic> json) {
    return EligibleCountry(
      id: json['id'] as int,
      countryCode: json['country_code'] as String,
      currency: json['currency'] as String,
      isMonetisationActive: json['is_monetisation_active'] as bool,
      // is_payout_active arrive parfois en int (0/1), parfois en bool
      isPayoutActive:
          json['is_payout_active'] == true || json['is_payout_active'] == 1,
      kycLevel: json['kyc_level'] as String,
      kycAllFieldsRequired: json['kyc_all_fields_required'] == true ||
          json['kyc_all_fields_required'] == 1,
      payoutMinThreshold: double.parse(json['payout_min_threshold'].toString()),
      payoutDailyLimit: double.parse(json['payout_daily_limit'].toString()),
      payoutWeeklyLimit: double.parse(json['payout_weekly_limit'].toString()),
      payoutMonthlyLimit: double.parse(json['payout_monthly_limit'].toString()),
      pspPayin: json['psp_payin'] as String,
      pspPayout: json['psp_payout'] as String,
      complianceNotes: json['compliance_notes'] as String?,
      fxSpread: double.parse(json['fx_spread'].toString()),
      roundingRule: json['rounding_rule'] as String,
      quoteTtlMinutes: json['quote_ttl_minutes'] as int,
      displayCurrency: json['display_currency'] as String,
      showBzcAmount:
          json['show_bzc_amount'] == true || json['show_bzc_amount'] == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_code': countryCode,
      'currency': currency,
      'is_monetisation_active': isMonetisationActive,
      'is_payout_active': isPayoutActive ? 1 : 0,
      'kyc_level': kycLevel,
      'kyc_all_fields_required': kycAllFieldsRequired ? 1 : 0,
      'payout_min_threshold': payoutMinThreshold.toStringAsFixed(2),
      'payout_daily_limit': payoutDailyLimit.toStringAsFixed(2),
      'payout_weekly_limit': payoutWeeklyLimit.toStringAsFixed(2),
      'payout_monthly_limit': payoutMonthlyLimit.toStringAsFixed(2),
      'psp_payin': pspPayin,
      'psp_payout': pspPayout,
      'compliance_notes': complianceNotes,
      'fx_spread': fxSpread.toStringAsFixed(2),
      'rounding_rule': roundingRule,
      'quote_ttl_minutes': quoteTtlMinutes,
      'display_currency': displayCurrency,
      'show_bzc_amount': showBzcAmount ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  EligibleCountry copyWith({
    int? id,
    String? countryCode,
    String? currency,
    bool? isMonetisationActive,
    bool? isPayoutActive,
    String? kycLevel,
    bool? kycAllFieldsRequired,
    double? payoutMinThreshold,
    double? payoutDailyLimit,
    double? payoutWeeklyLimit,
    double? payoutMonthlyLimit,
    String? pspPayin,
    String? pspPayout,
    String? complianceNotes,
    double? fxSpread,
    String? roundingRule,
    int? quoteTtlMinutes,
    String? displayCurrency,
    bool? showBzcAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EligibleCountry(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      currency: currency ?? this.currency,
      isMonetisationActive: isMonetisationActive ?? this.isMonetisationActive,
      isPayoutActive: isPayoutActive ?? this.isPayoutActive,
      kycLevel: kycLevel ?? this.kycLevel,
      kycAllFieldsRequired: kycAllFieldsRequired ?? this.kycAllFieldsRequired,
      payoutMinThreshold: payoutMinThreshold ?? this.payoutMinThreshold,
      payoutDailyLimit: payoutDailyLimit ?? this.payoutDailyLimit,
      payoutWeeklyLimit: payoutWeeklyLimit ?? this.payoutWeeklyLimit,
      payoutMonthlyLimit: payoutMonthlyLimit ?? this.payoutMonthlyLimit,
      pspPayin: pspPayin ?? this.pspPayin,
      pspPayout: pspPayout ?? this.pspPayout,
      complianceNotes: complianceNotes ?? this.complianceNotes,
      fxSpread: fxSpread ?? this.fxSpread,
      roundingRule: roundingRule ?? this.roundingRule,
      quoteTtlMinutes: quoteTtlMinutes ?? this.quoteTtlMinutes,
      displayCurrency: displayCurrency ?? this.displayCurrency,
      showBzcAmount: showBzcAmount ?? this.showBzcAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
