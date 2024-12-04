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
  });

  factory ExchangeTransactionModel.fromJson(Map<String, dynamic> json) {
    return ExchangeTransactionModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      type: json['type'] as String,
      fiatAmount: (json['fiat_amount'] as num).toDouble(),
      bzcAmount: (json['bzc_amount'] as num).toDouble(),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
