import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/data/models/monetization_account_model.dart';

import '../../repositories/user_repository.dart';

class GetMonetizationAccountsUseCase
    extends UseCase<List<MonetizationAccountModel>, NoParms> {
  final UserRepository _repository;

  GetMonetizationAccountsUseCase(this._repository);

  @override
  Future<List<MonetizationAccountModel>> call(params) async {
    return await _repository.getMonetizationAccounts();
  }
}
