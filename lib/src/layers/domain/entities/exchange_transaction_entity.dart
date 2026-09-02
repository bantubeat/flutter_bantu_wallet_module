abstract class ExchangeTransactionEntity {
  final int? id;
  final int? userId;
  final String type;
  final double fiatAmount;
  final double bzcAmount;
  final String? transactionNumber;
  final double fees;
  final double tvaRate;
  final double tvaAmount;
  final double? localAmount;
  final String? localCurrencyIso;
  final String? localCurrencySymbol;
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
    this.transactionNumber,
    this.fees = 0,
    this.tvaRate = 0,
    this.tvaAmount = 0,
    this.localAmount,
    this.localCurrencyIso,
    this.localCurrencySymbol,
  });
}
