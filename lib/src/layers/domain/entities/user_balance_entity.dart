import 'package:equatable/equatable.dart';

class UserBalanceEntity extends Equatable {
  final double bzc;
  final double eur;
  final double xaf;
  final String financialWalletNumber;
  final String beatzcoinWalletNumber;

  const UserBalanceEntity({
    required this.bzc,
    required this.eur,
    required this.xaf,
    required this.financialWalletNumber,
    required this.beatzcoinWalletNumber,
  });

  @override
  List<Object?> get props => [
        bzc,
        eur,
        xaf,
        financialWalletNumber,
        beatzcoinWalletNumber,
      ];
}
