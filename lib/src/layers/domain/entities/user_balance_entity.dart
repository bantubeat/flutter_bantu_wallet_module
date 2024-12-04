import 'package:equatable/equatable.dart';

class UserBalanceEntity extends Equatable {
  final double bzc;
  final double eur;
  final double xaf;

  const UserBalanceEntity({
    required this.bzc,
    required this.eur,
    required this.xaf,
  });

  @override
  List<Object?> get props => [bzc, eur, xaf];
}
