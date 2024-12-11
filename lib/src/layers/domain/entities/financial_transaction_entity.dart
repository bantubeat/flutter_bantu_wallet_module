abstract class FinancialTransactionEntity {
  final int id;
  final int userId;
  final EFinancialTxType type;
  final double oldBalance;
  final double newBalance;
  final double amount;
  final double inputAmount;
  final String inputCurrency;
  final String paymentRef;
  final String paymentMethod;
  final EFinancialTxStatus status;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String uuid;

  const FinancialTransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.oldBalance,
    required this.newBalance,
    required this.amount,
    required this.inputAmount,
    required this.inputCurrency,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.uuid,
    required this.paymentRef,
    this.description,
  });
}

enum EFinancialTxType {
  deposit('DEPOSIT'),
  withdrawal('WITHDRAWAL'),
  internalIn('INTERNAL_IN'),
  internalOut('INTERNAL_OUT');

  final String value;
  const EFinancialTxType(this.value);

  static EFinancialTxType fromString(String value) {
    switch (value) {
      case 'DEPOSIT':
        return EFinancialTxType.deposit;
      case 'WITHDRAWAL':
        return EFinancialTxType.withdrawal;
      case 'INTERNAL_IN':
        return EFinancialTxType.internalIn;
      case 'INTERNAL_OUT':
        return EFinancialTxType.internalOut;
      default:
        throw ArgumentError('Invalid transaction type: $value');
    }
  }
}

enum EFinancialTxStatus {
  pending('PENDING'),
  success('SUCCESS'),
  failed('FAILED');

  final String value;
  const EFinancialTxStatus(this.value);

  static EFinancialTxStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return EFinancialTxStatus.pending;
      case 'SUCCESS':
        return EFinancialTxStatus.success;
      case 'FAILED':
        return EFinancialTxStatus.failed;
      default:
        throw ArgumentError('Invalid FinancialTxStatus value: $value');
    }
  }
}
