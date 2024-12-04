import '../../domain/entities/exchange_bzc_pack_entity.dart';

class ExchangeBzcPackModel extends ExchangeBzcPackEntity {
  const ExchangeBzcPackModel({
    required super.id,
    required super.fiatAmount,
    required super.bzcAmount,
  });

  factory ExchangeBzcPackModel.fromJson(Map<String, dynamic> json) {
    return ExchangeBzcPackModel(
      id: json['id'] as int,
      fiatAmount: (json['fiat_amount'] as num).toDouble(),
      bzcAmount: (json['bzc_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fiat_amount': fiatAmount,
      'bzc_amount': bzcAmount,
    };
  }
}
