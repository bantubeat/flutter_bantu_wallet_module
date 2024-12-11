import '../../domain/entities/currency_item_entity.dart';

class CurrencyItemModel extends CurrencyItemEntity {
  const CurrencyItemModel({
    required super.code,
    required super.oneEurValue,
    required super.description,
  });

  factory CurrencyItemModel.fromJson(Map<String, dynamic> json) {
    return CurrencyItemModel(
      code: json['code'],
      oneEurValue: double.parse(json['one_eur_value'].toString()),
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
