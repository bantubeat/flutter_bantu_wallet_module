import '../../domain/entities/user_balance_entity.dart';

class UserBalanceModel extends UserBalanceEntity {
  const UserBalanceModel({
    required super.bzc,
    required super.eur,
    required super.xaf,
    required super.financialWalletNumber,
    required super.beatzcoinWalletNumber,
  });

  factory UserBalanceModel.fromJson(Map<String, dynamic> json) {
    return UserBalanceModel(
      bzc: double.parse(json['BZC'].toString()),
      eur: double.parse(json['EUR'].toString()),
      xaf: double.parse(json['XAF'].toString()),
      financialWalletNumber: json['financial_wallet_number'].toString(),
      beatzcoinWalletNumber: json['beatzcoin_wallet_number'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BZC': bzc,
      'EUR': eur,
      'XAF': xaf,
      'financial_wallet_number': financialWalletNumber,
      'beatzcoin_wallet_number': beatzcoinWalletNumber,
    };
  }
}
