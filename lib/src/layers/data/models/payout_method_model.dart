import '../../domain/entities/payout_method_entity.dart';

class PayoutOperatorModel extends PayoutOperatorEntity {
  const PayoutOperatorModel({
    required super.name,
    required super.code,
  });

  factory PayoutOperatorModel.fromJson(Map<String, dynamic> json) {
    return PayoutOperatorModel(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }
}

class PayoutMethodModel extends PayoutMethodEntity {
  const PayoutMethodModel({
    required super.type,
    required super.label,
    super.operators,
  });

  factory PayoutMethodModel.fromJson(Map<String, dynamic> json) {
    final rawOperators = (json['operators'] as List?) ?? const [];
    return PayoutMethodModel(
      type: json['type'] as String? ?? '',
      label: json['label'] as String? ?? '',
      operators: rawOperators
          .map((e) => PayoutOperatorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PayoutMethodsResultModel extends PayoutMethodsResultEntity {
  const PayoutMethodsResultModel({
    required super.countryCode,
    super.pspFallback,
    super.methods,
  });

  factory PayoutMethodsResultModel.fromJson(Map<String, dynamic> json) {
    final rawMethods = (json['methods'] as List?) ?? const [];
    return PayoutMethodsResultModel(
      countryCode: json['country_code'] as String? ?? '',
      pspFallback: json['psp_fallback'] as String?,
      methods: rawMethods
          .map((e) => PayoutMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}