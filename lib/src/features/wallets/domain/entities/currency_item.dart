import 'package:equatable/equatable.dart';

class CurrencyItem extends Equatable {
  final String code;
  final double oneEurValue;
  final String description;

  const CurrencyItem({
    required this.code,
    required this.oneEurValue,
    required this.description,
  });

  @override
  List<Object?> get props => [code, oneEurValue, description];

  factory CurrencyItem.none() {
    return const CurrencyItem(code: '', oneEurValue: 0, description: '');
  }
}
