import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../entities/financial_transaction_entity.dart';
import '../repositories/balance_repository.dart';

class GetTransactionsHistoryUseCase
    implements UseCase<List<FinancialTransactionEntity>, _Parms> {
  final BalanceRepository _repository;

  const GetTransactionsHistoryUseCase(this._repository);

  @override
  Future<List<FinancialTransactionEntity>> call(params) async {
    return _repository.getTransactions(page: params.page, limit: params.limit);
  }
}

typedef _Parms = ({int page, int limit});
