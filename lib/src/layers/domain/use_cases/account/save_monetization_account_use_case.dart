import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/user_repository.dart';

class SaveMonetizationAccountUseCase extends UseCase<void, SaveMonetizationAccountParams> {
  final UserRepository _repository;

  SaveMonetizationAccountUseCase(this._repository);

  @override
  Future<void> call(params) async {
    return await _repository.saveMonetizationAccount(
      accountType: params.accountType,
      fiscalIdNumber: params.fiscalIdNumber,
      documentUrl: params.documentUrl,
    );
  }
}

class SaveMonetizationAccountParams {
  final String accountType;
  final String fiscalIdNumber;
  final String documentUrl;

  const SaveMonetizationAccountParams({
    required this.accountType,
    required this.fiscalIdNumber,
    required this.documentUrl,
  });
}
