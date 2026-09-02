import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class TokenPackEntity extends Equatable {
  final String label;
  final double tokenCount;
  final double unitPrice;
  final double price;
  final String? currencyIso;
  final String? symbol;

  const TokenPackEntity({
    required this.label,
    required this.tokenCount,
    required this.unitPrice,
    required this.price,
    this.currencyIso,
    this.symbol,
  });

  factory TokenPackEntity.fromJson(Map<String, dynamic> json) {
    return TokenPackEntity(
      label: json['label'] as String,
      tokenCount: (json['token_count'] as num).toDouble(),
      unitPrice: double.parse(json['unit_price'].toString()),
      price: double.parse(json['price'].toString()),
      currencyIso: json['currency_iso'] as String?,
      symbol: json['symbol'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [label, tokenCount, unitPrice, price, currencyIso, symbol];
}

abstract class TokenPriceEntity extends Equatable {
  final int? id;
  final int? zoneId;
  final String countryCode;
  final double unitPrice;
  final String currencyIso;
  final String symbol;
  final bool? isActive;
  final MonetaryZone? zone;
  final List<TokenPackEntity> packs;

  const TokenPriceEntity({
    required this.countryCode,
    required this.unitPrice,
    required this.currencyIso,
    required this.symbol,
    required this.packs,
    this.id,
    this.zoneId,
    this.isActive,
    this.zone,
  });

  @override
  List<Object?> get props => [
        id,
        zoneId,
        countryCode,
        unitPrice,
        currencyIso,
        symbol,
        isActive,
        zone,
        packs,
      ];
}
