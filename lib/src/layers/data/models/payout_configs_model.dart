import '../../domain/entities/payout_configs_entity.dart';

class PayoutOperatorInfoModel extends PayoutOperatorInfoEntity {
  const PayoutOperatorInfoModel({
    required super.name,
    required super.codeService,
    required super.codeOperator,
  });

  factory PayoutOperatorInfoModel.fromJson(Map<String, dynamic> json) {
    return PayoutOperatorInfoModel(
      name: json['name'] as String? ?? '',
      codeService: json['code_service'] as String? ?? '',
      codeOperator: json['code_operator'] as String? ?? '',
    );
  }
}

class MobileMoneyPayoutModel extends MobileMoneyPayoutEntity {
  const MobileMoneyPayoutModel({
    required super.isActive,
    required super.psp,
    super.operators,
    super.phoneFormat,
    super.otpRequired,
    super.feeFixedPct,
    super.feeOperatorPct,
    super.taxFixedPct,
    super.minWithdrawal,
    super.maxWithdrawal,
    super.maxDaily,
  });

  factory MobileMoneyPayoutModel.fromJson(Map<String, dynamic> json) {
    final rawOperators = (json['operators'] as List?) ?? const [];
    return MobileMoneyPayoutModel(
      isActive: json['is_active'] as bool? ?? false,
      psp: json['psp'] as String? ?? '',
      operators: rawOperators
          .map(
            (e) => PayoutOperatorInfoModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      phoneFormat: json['phone_format'] as String?,
      otpRequired: json['otp_required'] as bool? ?? false,
      feeFixedPct: (json['fee_fixed_pct'] as num?)?.toDouble() ?? 0,
      feeOperatorPct: (json['fee_operator_pct'] as num?)?.toDouble() ?? 0,
      taxFixedPct: (json['tax_fixed_pct'] as num?)?.toDouble() ?? 0,
      minWithdrawal: (json['min_withdrawal'] as num?)?.toDouble() ?? 0,
      maxWithdrawal: (json['max_withdrawal'] as num?)?.toDouble() ?? 0,
      maxDaily: (json['max_daily'] as num?)?.toDouble() ?? 0,
    );
  }
}

class BankInfoModel extends BankInfoEntity {
  const BankInfoModel({
    required super.nom,
    required super.code,
    required super.sigle,
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) {
    return BankInfoModel(
      nom: json['nom'] as String? ?? '',
      code: json['code'] as String? ?? '',
      sigle: json['sigle'] as String? ?? '',
    );
  }
}

class BankPayoutModel extends BankPayoutEntity {
  const BankPayoutModel({
    required super.isActive,
    required super.psp,
    super.banks,
    super.feeFixedPct,
    super.feeOperatorPct,
    super.taxFixedPct,
    super.minWithdrawal,
    super.maxDaily,
  });

  factory BankPayoutModel.fromJson(Map<String, dynamic> json) {
    final rawBanks = (json['banks'] as List?) ?? const [];
    return BankPayoutModel(
      isActive: json['is_active'] as bool? ?? false,
      psp: json['psp'] as String? ?? '',
      banks: rawBanks
          .map((e) => BankInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      feeFixedPct: (json['fee_fixed_pct'] as num?)?.toDouble() ?? 0,
      feeOperatorPct: (json['fee_operator_pct'] as num?)?.toDouble() ?? 0,
      taxFixedPct: (json['tax_fixed_pct'] as num?)?.toDouble() ?? 0,
      minWithdrawal: (json['min_withdrawal'] as num?)?.toDouble() ?? 0,
      maxDaily: (json['max_daily'] as num?)?.toDouble() ?? 0,
    );
  }
}

class PayoutConfigsModel extends PayoutConfigsEntity {
  const PayoutConfigsModel({
    required super.countryCode,
    super.mobileMoney,
    super.bank,
  });

  factory PayoutConfigsModel.fromJson(Map<String, dynamic> json) {
    final mobileMoneyJson = json['mobile_money'] as Map<String, dynamic>?;
    final bankJson = json['bank'] as Map<String, dynamic>?;
    return PayoutConfigsModel(
      countryCode: json['country_code'] as String? ?? '',
      mobileMoney: mobileMoneyJson != null
          ? MobileMoneyPayoutModel.fromJson(mobileMoneyJson)
          : null,
      bank: bankJson != null ? BankPayoutModel.fromJson(bankJson) : null,
    );
  }
}
