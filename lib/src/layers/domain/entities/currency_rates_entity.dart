import 'package:equatable/equatable.dart';

class CurrencyRatesEntity extends Equatable {
  final double oneEurInBzc;
  final double oneEurInXaf;

  const CurrencyRatesEntity({
    required this.oneEurInBzc,
    required this.oneEurInXaf,
  });

  @override
  List<Object?> get props => [oneEurInBzc, oneEurInXaf];
}
