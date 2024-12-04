import '../../../core/use_cases/use_case.dart';
import '../entities/user_balance_entity.dart';
import '../repositories/balance_repository.dart';

class GetUserBalanceUseCase extends UseCase<UserBalanceEntity, NoParms> {
  final BalanceRepository _repository;

  const GetUserBalanceUseCase(this._repository);

  @override
  Future<UserBalanceEntity> call(params) {
    return _repository.getUserBalance();
  }
}
