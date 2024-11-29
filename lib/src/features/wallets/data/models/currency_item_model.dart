import '../../domain/entities/currency_item.dart';

class CurrencyItemModel extends CurrencyItem {
  const CurrencyItemModel({
    required super.code,
    required super.oneEurValue,
    required super.description,
  });

  factory CurrencyItemModel.fromJson(Map<String, dynamic> json) {
    return CurrencyItemModel(
      code: json['code'],
      oneEurValue: json['one_eur_value'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'one_eur_value': oneEurValue,
      'description': description,
    };
  }
}
