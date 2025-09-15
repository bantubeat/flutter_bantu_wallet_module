import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/payment_preference_input.dart';

import '../repositories/balance_repository.dart';

class UpdatePaymentPreferencesUseCase
    extends UseCase<void, PaymentPreferenceInput> {
  final BalanceRepository _repository;

  const UpdatePaymentPreferencesUseCase(this._repository);

  @override
  Future<void> call(PaymentPreferenceInput input) async {
    await _repository.updatePaymentPreferences(input);
  }
}
