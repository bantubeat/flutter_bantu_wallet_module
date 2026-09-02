import 'package:equatable/equatable.dart';

class PayoutOperatorEntity extends Equatable {
  final String name;
  final String code;

  const PayoutOperatorEntity({required this.name, required this.code});

  @override
  List<Object?> get props => [name, code];
}

class PayoutMethodEntity extends Equatable {
  final String type;
  final String label;
  final List<PayoutOperatorEntity> operators;

  const PayoutMethodEntity({
    required this.type,
    required this.label,
    this.operators = const [],
  });

  @override
  List<Object?> get props => [type, label, operators];
}

class PayoutMethodsResultEntity extends Equatable {
  final String countryCode;
  final String? pspFallback;
  final List<PayoutMethodEntity> methods;

  const PayoutMethodsResultEntity({
    required this.countryCode,
    this.pspFallback,
    this.methods = const [],
  });

  List<PayoutOperatorEntity> get mobileMoneyOperators {
    return methods
        .where((m) => m.type == 'mobile_money')
        .expand((m) => m.operators)
        .toList();
  }

  @override
  List<Object?> get props => [countryCode, pspFallback, methods];
}