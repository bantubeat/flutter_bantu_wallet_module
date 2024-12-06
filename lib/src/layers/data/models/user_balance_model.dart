import '../../domain/entities/user_balance_entity.dart';

class UserBalanceModel extends UserBalanceEntity {
  const UserBalanceModel({
    required super.bzc,
    required super.eur,
    required super.xaf,
  });

  factory UserBalanceModel.fromJson(Map<String, dynamic> json) {
    return UserBalanceModel(
      bzc: json['BZC'],
      eur: json['EUR'],
      xaf: json['XAF'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BZC': bzc,
      'EUR': eur,
      'XAF': xaf,
    };
  }
}
