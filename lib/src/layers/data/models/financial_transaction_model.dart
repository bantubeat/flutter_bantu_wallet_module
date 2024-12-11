import '../../domain/entities/financial_transaction_entity.dart';

class FinancialTransactionModel extends FinancialTransactionEntity {
  const FinancialTransactionModel({
    required super.id,
    required super.uuid,
    required super.userId,
    required super.type,
    required super.oldBalance,
    required super.newBalance,
    required super.amount,
    required super.inputAmount,
    required super.inputCurrency,
    required super.paymentMethod,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.paymentRef,
    super.description,
  });

  factory FinancialTransactionModel.fromJson(Map<String, dynamic> json) {
    return FinancialTransactionModel(
      id: json['id'],
      userId: json['user_id'],
      uuid: json['uuid'],
      type: EFinancialTxType.fromString(json['type']),
      oldBalance: (json['old_balance'] as num).toDouble(),
      newBalance: (json['new_balance'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      inputAmount: (json['input_amount'] as num).toDouble(),
      inputCurrency: json['input_currency'],
      paymentRef: json['payment_ref'],
      paymentMethod: json['payment_method'],
      status: EFinancialTxStatus.fromString(json['status']),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.value,
      'old_balance': oldBalance,
      'new_balance': newBalance,
      'amount': amount,
      'input_amount': inputAmount,
      'input_currency': inputCurrency,
      'payment_ref': paymentRef,
      'payment_method': paymentMethod,
      'status': status.value,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'uuid': uuid,
    };
  }
}
