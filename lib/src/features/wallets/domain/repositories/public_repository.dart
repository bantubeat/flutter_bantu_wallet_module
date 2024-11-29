import '../entities/currency_item.dart';

abstract class PublicRepository {
  Future<List<CurrencyItem>> getAllCurrencies();
}
