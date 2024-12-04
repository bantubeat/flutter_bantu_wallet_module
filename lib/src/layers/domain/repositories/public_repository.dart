import '../entities/currency_item_entity.dart';
import '../entities/currency_rates_entity.dart';

abstract class PublicRepository {
  Future<List<CurrencyItemEntity>> getAllCurrencies();

  Future<CurrencyRatesEntity> getBzcCurrencyRates();
}
