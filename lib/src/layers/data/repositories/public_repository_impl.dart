import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/currency_rates_entity.dart';

import '../../domain/entities/currency_item_entity.dart';
import '../../domain/repositories/public_repository.dart';
import '../data_sources/bantubeat_api_data_source.dart';

class PublicRepositoryImpl implements PublicRepository {
  final BantubeatApiDataSource _bantubeatApiDataSource;

  PublicRepositoryImpl(this._bantubeatApiDataSource);

  @override
  Future<List<CurrencyItemEntity>> getAllCurrencies() async {
    try {
      final result = await _bantubeatApiDataSource.get$publicAllCurrencies();
      return result.map((e) => e as CurrencyItemEntity).toList();
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<CurrencyRatesEntity> getBzcCurrencyRates() {
    return _bantubeatApiDataSource.get$publicCurrencies();
  }
}
