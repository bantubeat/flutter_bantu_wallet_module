import '../entities/currency_item_entity.dart';

abstract class PublicRepository {
  Future<List<CurrencyItemEntity>> getAllCurrencies();
}
