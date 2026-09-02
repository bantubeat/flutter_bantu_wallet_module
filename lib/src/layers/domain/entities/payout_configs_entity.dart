import 'package:equatable/equatable.dart';

class PayoutOperatorInfoEntity extends Equatable {
  final String name;
  final String codeService;
  final String codeOperator;

  const PayoutOperatorInfoEntity({
    required this.name,
    required this.codeService,
    required this.codeOperator,
  });

  @override
  List<Object?> get props => [name, codeService, codeOperator];
}

class MobileMoneyPayoutEntity extends Equatable {
  final bool isActive;
  final String psp;
  final List<PayoutOperatorInfoEntity> operators;
  final String? phoneFormat;
  final bool otpRequired;
  final double feeFixedPct;
  final double feeOperatorPct;
  final double taxFixedPct;
  final double minWithdrawal;
  final double maxWithdrawal;
  final double maxDaily;

  const MobileMoneyPayoutEntity({
    required this.isActive,
    required this.psp,
    this.operators = const [],
    this.phoneFormat,
    this.otpRequired = false,
    this.feeFixedPct = 0,
    this.feeOperatorPct = 0,
    this.taxFixedPct = 0,
    this.minWithdrawal = 0,
    this.maxWithdrawal = 0,
    this.maxDaily = 0,
  });

  @override
  List<Object?> get props => [
        isActive,
        psp,
        operators,
        phoneFormat,
        otpRequired,
        feeFixedPct,
        feeOperatorPct,
        taxFixedPct,
        minWithdrawal,
        maxWithdrawal,
        maxDaily,
      ];
}

class BankInfoEntity extends Equatable {
  final String nom;
  final String code;
  final String sigle;

  const BankInfoEntity({
    required this.nom,
    required this.code,
    required this.sigle,
  });

  @override
  List<Object?> get props => [nom, code, sigle];
}

class BankPayoutEntity extends Equatable {
  final bool isActive;
  final String psp;
  final List<BankInfoEntity> banks;
  final double feeFixedPct;
  final double feeOperatorPct;
  final double taxFixedPct;
  final double minWithdrawal;
  final double maxDaily;

  const BankPayoutEntity({
    required this.isActive,
    required this.psp,
    this.banks = const [],
    this.feeFixedPct = 0,
    this.feeOperatorPct = 0,
    this.taxFixedPct = 0,
    this.minWithdrawal = 0,
    this.maxDaily = 0,
  });

  @override
  List<Object?> get props => [
        isActive,
        psp,
        banks,
        feeFixedPct,
        feeOperatorPct,
        taxFixedPct,
        minWithdrawal,
        maxDaily,
      ];
}

class PayoutConfigsEntity extends Equatable {
  final String countryCode;
  final MobileMoneyPayoutEntity? mobileMoney;
  final BankPayoutEntity? bank;

  const PayoutConfigsEntity({
    required this.countryCode,
    this.mobileMoney,
    this.bank,
  });

  @override
  List<Object?> get props => [countryCode, mobileMoney, bank];
}
