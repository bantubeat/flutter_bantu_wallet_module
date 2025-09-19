import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../entities/financial_transaction_entity.dart';
import '../../repositories/balance_repository.dart';

class GetTransactionsUseCase
    implements
        UseCase<List<FinancialTransactionEntity>, GetTransactionsParams> {
  final BalanceRepository _repository;

  const GetTransactionsUseCase(this._repository);

  @override
  Future<List<FinancialTransactionEntity>> call(params) async {
    return _repository.getTransactions(
      page: params.page,
      limit: params.limit,
      isBzcAccount: params.isBzcAccount,
      statusList: params.statuses.isNotEmpty ? params.statuses : null,
      typesList: params.types.isNotEmpty ? params.types : null,
    );
  }
}

class GetTransactionsParams {
  final List<EFinancialTxStatus> statuses;
  final List<EFinancialTxType> types;
  final bool isBzcAccount;
  final int page;
  final int limit;

  const GetTransactionsParams({
    required this.statuses,
    required this.types,
    required this.isBzcAccount,
    required this.page,
    required this.limit,
  });
}
