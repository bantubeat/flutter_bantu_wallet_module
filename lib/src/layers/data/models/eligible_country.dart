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
    // Fonction utilitaire pour parser les booléens de manière sécurisée
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return false;
    }

    // Fonction utilitaire pour parser les doubles de manière sécurisée
    double parseDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        final cleaned = value.replaceAll(',', '.').trim();
        return double.tryParse(cleaned) ?? defaultValue;
      }
      return defaultValue;
    }

    // Fonction utilitaire pour parser les entiers de manière sécurisée
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    // Fonction utilitaire pour parser les dates
    DateTime parseDate(dynamic value, {DateTime? defaultValue}) {
      if (value == null) {
        return defaultValue ?? DateTime.now();
      }
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return defaultValue ?? DateTime.now();
        }
      }
      return defaultValue ?? DateTime.now();
    }

    // Fonction utilitaire pour parser les strings
    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      if (value is int || value is double) return value.toString();
      return defaultValue;
    }

    return EligibleCountry(
      id: parseInt(json['id'], defaultValue: -1),
      countryCode: parseString(json['country_code']),
      currency: parseString(json['currency']),
      isMonetisationActive: parseBool(json['is_monetisation_active']),
      isPayoutActive: parseBool(json['is_payout_active']),
      kycLevel: parseString(json['kyc_level']),
      kycAllFieldsRequired: parseBool(json['kyc_all_fields_required']),
      payoutMinThreshold: parseDouble(json['payout_min_threshold']),
      payoutDailyLimit: parseDouble(json['payout_daily_limit']),
      payoutWeeklyLimit: parseDouble(json['payout_weekly_limit']),
      payoutMonthlyLimit: parseDouble(json['payout_monthly_limit']),
      pspPayin: parseString(json['psp_payin']),
      pspPayout: parseString(json['psp_payout']),
      complianceNotes: json['compliance_notes'] as String?,
      fxSpread: parseDouble(json['fx_spread'], defaultValue: 1.0),
      roundingRule: parseString(json['rounding_rule'], defaultValue: 'half_up'),
      quoteTtlMinutes: parseInt(json['quote_ttl_minutes'], defaultValue: 60),
      displayCurrency: parseString(json['display_currency']),
      showBzcAmount: parseBool(json['show_bzc_amount']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
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
