import '../../domain/entities/token_price_entity.dart';
import '../../domain/entities/user_entity.dart';

class TokenPriceModel extends TokenPriceEntity {
  const TokenPriceModel({
    required super.countryCode,
    required super.unitPrice,
    required super.currencyIso,
    required super.symbol,
    required super.packs,
    super.id,
    super.zoneId,
    super.isActive,
    super.zone,
  });

  factory TokenPriceModel.fromJson(Map<String, dynamic> json) {
    return TokenPriceModel(
      id: json['id'] as int?,
      zoneId: json['zone_id'] as int?,
      countryCode: json['country_code'] as String? ?? '',
      unitPrice: double.parse(json['unit_price'].toString()),
      currencyIso: json['currency_iso'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      isActive: json['is_actif'] == true || json['is_actif'] == 1,
      zone: json['zone'] != null
          ? MonetaryZone.fromJson(json['zone'] as Map<String, dynamic>)
          : null,
      packs: (json['packs'] as List)
          .map((e) => TokenPackEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
