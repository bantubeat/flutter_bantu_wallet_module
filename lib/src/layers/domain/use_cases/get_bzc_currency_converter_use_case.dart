import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../entities/currency_rates_entity.dart';
import '../repositories/public_repository.dart';

class GetBzcCurrencyConverterUseCase
    extends UseCase<BzcCurrencyConverter, NoParms> {
  final PublicRepository _repository;

  GetBzcCurrencyConverterUseCase(this._repository);

  @override
  Future<BzcCurrencyConverter> call(params) async {
    try {
      final rates = await _repository.getBzcCurrencyRates();
      return BzcCurrencyConverter(rates);
    } catch (e) {
      throw Exception('Failed to fetch currency rates: $e');
    }
  }
}

final class BzcCurrencyConverter {
  final CurrencyRatesEntity _rates;

  const BzcCurrencyConverter(this._rates);

  double eurToXaf(double amountInEur) => amountInEur * _rates.oneEurInXaf;

  double xafToEur(double amountInXaf) => amountInXaf / _rates.oneEurInXaf;

  double eurToBzc(double amountInEur) => amountInEur * _rates.oneEurInBzc;

  double bzcToEur(double amountInBzc) => amountInBzc / _rates.oneEurInBzc;

  double bzcToXaf(double amountInBzc) {
    final amountInEur = bzcToEur(amountInBzc);
    return eurToXaf(amountInEur);
  }

  double xafToBzc(double amountInXaf) {
    final amountInEur = xafToEur(amountInXaf);
    return eurToBzc(amountInEur);
  }
}
