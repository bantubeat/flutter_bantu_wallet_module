import '../../../../core/use_cases/use_case.dart';
import '../entities/currency_item.dart';
import '../repositories/public_repository.dart';

class GetAllCurrenciesUseCase extends UseCase<List<CurrencyItem>, Null> {
  final PublicRepository _repository;

  const GetAllCurrenciesUseCase(this._repository);

  @override
  Future<List<CurrencyItem>> call(Null params) {
    return _repository.getAllCurrencies();
  }
}
