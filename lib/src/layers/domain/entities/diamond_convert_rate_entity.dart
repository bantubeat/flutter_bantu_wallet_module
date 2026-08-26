import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class DiamondConvertRateEntity extends Equatable {
  final MonetaryZone zone;
  final double unitPrice;
  final String currencyIso;
  final String currencySymbol;

  const DiamondConvertRateEntity({
    required this.zone,
    required this.unitPrice,
    required this.currencyIso,
    required this.currencySymbol,
  });

  @override
  List<Object?> get props => [zone, unitPrice, currencyIso, currencySymbol];
}
