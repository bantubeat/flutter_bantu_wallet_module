import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/payment_preference_input.dart';

import '../../repositories/balance_repository.dart';

class UpdatePaymentPreferencesUseCase
    extends UseCase<PaymentPreferenceEntity, PaymentPreferenceInput> {
  final BalanceRepository _repository;

  const UpdatePaymentPreferencesUseCase(this._repository);

  @override
  Future<PaymentPreferenceEntity> call(PaymentPreferenceInput input) {
    return _repository.updatePaymentPreferences(input);
  }
}
