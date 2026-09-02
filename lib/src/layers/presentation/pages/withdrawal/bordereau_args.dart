import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/withdrawal_simulation_entity.dart';

class BordereauArgs {
  final WithdrawalSimulationEntity simulation;
  final PaymentPreferenceEntity paymentPreference;

  const BordereauArgs({
    required this.simulation,
    required this.paymentPreference,
  });
}
