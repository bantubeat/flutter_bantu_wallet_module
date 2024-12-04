import 'package:equatable/equatable.dart';

abstract class ExchangeBzcPackEntity extends Equatable {
  final int id;
  final double fiatAmount;
  final double bzcAmount;

  const ExchangeBzcPackEntity({
    required this.id,
    required this.fiatAmount,
    required this.bzcAmount,
  });

  @override
  List<Object?> get props => [id, fiatAmount, bzcAmount];
}
