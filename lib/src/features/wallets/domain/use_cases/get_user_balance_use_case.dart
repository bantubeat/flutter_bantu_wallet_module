import '../../../../core/use_cases/use_case.dart';
import '../entities/user_balance.dart';
import '../repositories/balance_repository.dart';

class GetUserBalanceUseCase extends UseCase<UserBalance, Null> {
  final BalanceRepository _repository;

  const GetUserBalanceUseCase(this._repository);

  @override
  Future<UserBalance> call(Null params) {
    return _repository.getUserBalance();
  }
}
