import '../../domain/entities/currency_rates_entity.dart';

class CurrencyRatesModel extends CurrencyRatesEntity {
  const CurrencyRatesModel({
    required super.oneEurInBzc,
    required super.oneEurInXaf,
  });

  factory CurrencyRatesModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRatesModel(
      oneEurInBzc: double.parse(json['one_eur_in_bzc'].toString()),
      oneEurInXaf: double.parse(json['one_eur_in_xaf'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'one_eur_in_bzc': oneEurInBzc,
      'one_eur_in_xaf': oneEurInXaf,
    };
  }
}
