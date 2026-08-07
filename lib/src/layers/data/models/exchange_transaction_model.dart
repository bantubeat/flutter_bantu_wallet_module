import '../../domain/entities/exchange_transaction_entity.dart';

class ExchangeTransactionModel extends ExchangeTransactionEntity {
  const ExchangeTransactionModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.fiatAmount,
    required super.bzcAmount,
    required super.createdAt,
    required super.updatedAt,
    super.transactionNumber,
    super.fees,
    super.tvaRate,
    super.tvaAmount,
    super.localAmount,
    super.localCurrencyIso,
    super.localCurrencySymbol,
  });

  factory ExchangeTransactionModel.fromJson(Map<String, dynamic> json) {
    final tva = json['tva'] as Map<String, dynamic>?;
    final localAmount = json['local_amount'] as Map<String, dynamic>?;
    return ExchangeTransactionModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      type: json['type'] as String,
      fiatAmount: (json['fiat_amount'] as num).toDouble(),
      bzcAmount: (json['bzc_amount'] as num).toDouble(),
      transactionNumber: json['transaction_number'] as String?,
      fees: (json['fees'] as num?)?.toDouble() ?? 0,
      tvaRate: (tva?['rate'] as num?)?.toDouble() ?? 0,
      tvaAmount: (tva?['amount'] as num?)?.toDouble() ?? 0,
      localAmount: (localAmount?['amount'] as num?)?.toDouble(),
      localCurrencyIso: localAmount?['currency_iso'] as String?,
      localCurrencySymbol: localAmount?['symbol'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'fiat_amount': fiatAmount,
      'bzc_amount': bzcAmount,
      'transaction_number': transactionNumber,
      'fees': fees,
      'tva': {
        'rate': tvaRate,
        'amount': tvaAmount,
      },
      'local_amount': {
        'amount': localAmount,
        'currency_iso': localCurrencyIso,
        'symbol': localCurrencySymbol,
      },
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
