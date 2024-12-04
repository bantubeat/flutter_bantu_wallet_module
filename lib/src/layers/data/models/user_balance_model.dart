import '../../domain/entities/user_balance.dart';

class UserBalanceModel extends UserBalance {
  const UserBalanceModel({
    required super.bzc,
    required super.eur,
    required super.xaf,
  });

  factory UserBalanceModel.fromJson(Map<String, dynamic> json) {
    return UserBalanceModel(
      bzc: json['bzc'],
      eur: json['eur'],
      xaf: json['xaf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bzc': bzc,
      'eur': eur,
      'xaf': xaf,
    };
  }
}
