import '../../../core/use_cases/use_case.dart';
import '../entities/currency_item_entity.dart';
import '../repositories/public_repository.dart';

class GetAllCurrenciesUseCase
    extends UseCase<List<CurrencyItemEntity>, NoParms> {
  final PublicRepository _repository;

  const GetAllCurrenciesUseCase(this._repository);

  @override
  Future<List<CurrencyItemEntity>> call(NoParms params) {
    return _repository.getAllCurrencies();
  }
}
