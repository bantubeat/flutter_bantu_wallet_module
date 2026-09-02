import '../../domain/entities/diamond_convert_rate_entity.dart';
import '../../domain/entities/user_entity.dart';

class DiamondConvertRateModel extends DiamondConvertRateEntity {
  const DiamondConvertRateModel({
    required super.zone,
    required super.unitPrice,
    required super.currencyIso,
    required super.currencySymbol,
  });

  factory DiamondConvertRateModel.fromJson(Map<String, dynamic> json) {
    return DiamondConvertRateModel(
      zone: json['zone'] != null
          ? MonetaryZone.fromJson(json['zone'] as Map<String, dynamic>)
          : const MonetaryZone(
              id: 0,
              name: '',
              currencyIso: '',
              currencyName: '',
              currencySymbol: '',
            ),
      unitPrice: double.parse(json['unit_price'].toString()),
      currencyIso: json['currency_iso'] as String? ?? '',
      currencySymbol: json['currency_symbol'] as String? ?? '',
    );
  }
}
