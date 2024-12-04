abstract class ExchangeTransactionEntity {
  final int? id;
  final int? userId;
  final String type;
  final double fiatAmount;
  final double bzcAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExchangeTransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.fiatAmount,
    required this.bzcAmount,
    required this.createdAt,
    required this.updatedAt,
  });
}
