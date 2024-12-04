import 'package:equatable/equatable.dart';

class CurrencyItemEntity extends Equatable {
  final String code;
  final double oneEurValue;
  final String description;

  const CurrencyItemEntity({
    required this.code,
    required this.oneEurValue,
    required this.description,
  });

  @override
  List<Object?> get props => [code, oneEurValue, description];

  factory CurrencyItemEntity.none() {
    return const CurrencyItemEntity(code: '', oneEurValue: 0, description: '');
  }
}
