import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';

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
      accountType: params.accountType,
      statusList: params.statuses.isNotEmpty ? params.statuses : null,
      typesList: params.types.isNotEmpty ? params.types : null,
    );
  }
}

class GetTransactionsParams {
  final List<EFinancialTxStatus> statuses;
  final List<EFinancialTxType> types;
  final AccountType accountType;
  final int page;
  final int limit;

  const GetTransactionsParams({
    required this.statuses,
    required this.types,
    required this.accountType,
    required this.page,
    required this.limit,
  });
}
