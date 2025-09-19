import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/payment_preference_entity.dart';
import '../../repositories/balance_repository.dart';

class GetPaymentPreferencesUseCase
    extends UseCase<List<PaymentPreferenceEntity>, NoParms> {
  final BalanceRepository _repository;

  const GetPaymentPreferencesUseCase(this._repository);

  @override
  Future<List<PaymentPreferenceEntity>> call(params) {
    return _repository.getPaymentPreferences();
  }
}
