import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../entities/transaction_history_item_entity.dart';
import '../repositories/balance_repository.dart';

class GetTransactionsHistoryUseCase
    implements UseCase<List<TransactionHistoryItemEntity>, _Parms> {
  final BalanceRepository _repository;

  const GetTransactionsHistoryUseCase(this._repository);

  @override
  Future<List<TransactionHistoryItemEntity>> call(params) async {
    return _repository.getTransactions(page: params.page, limit: params.limit);
  }
}

typedef _Parms = ({int page, int limit});
