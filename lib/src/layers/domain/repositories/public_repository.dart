import 'package:flutter_bantu_wallet_module/src/layers/data/models/eligible_country.dart';

import '../entities/currency_item_entity.dart';
import '../entities/currency_rates_entity.dart';
import '../entities/token_price_entity.dart';

abstract class PublicRepository {
  Future<List<CurrencyItemEntity>> getAllCurrencies();
  Future<List<EligibleCountry>?> checkMonetizationEligibleCountries([
    String? countryCode,
  ]);
  Future<CurrencyRatesEntity> getBzcCurrencyRates();
  Future<TokenPriceEntity> getTokenPacks();
}
