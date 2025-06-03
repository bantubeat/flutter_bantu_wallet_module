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

  double eurToXaf(double amountInEur) {
    return (amountInEur * _rates.oneEurInXaf).roundToDouble();
  }

  double xafToEur(double amountInXaf) => amountInXaf / _rates.oneEurInXaf;

  double eurToBzc(double amountInEur) => amountInEur * _rates.oneEurInBzc;

  /// Use same formula as the backend ie:
  /// ```php
  /// $bzcQuantity = $request->quantity;
  ///	$oneEurInBzc = Setting::getValueByKey(Setting::ONE_EUR_IN_BZC);
  ///	$fiatAmount = ((($bzcQuantity / $oneEurInBzc) * 0.7) / 1.21) * 0.98;
  ///```
  double bzcToEur(double amountInBzc, {required bool applyFees}) {
    if (!applyFees) return amountInBzc / _rates.oneEurInBzc;
    // Multiply 0.7 our percentage
    // Divide by 1.12 we remove TVA
    // Multiply 0.98 transaction fees
    //ODL: return (((amountInBzc / _rates.oneEurInBzc) * 0.7) / 1.21) * 0.98;
    return ((amountInBzc / _rates.oneEurInBzc) * 0.7) * 0.98;
  }

  double bzcToXaf(double amountInBzc, {required bool applyFees}) {
    final amountInEur = bzcToEur(amountInBzc, applyFees: applyFees);
    return eurToXaf(amountInEur);
  }

  double xafToBzc(double amountInXaf) {
    final amountInEur = xafToEur(amountInXaf);
    return eurToBzc(amountInEur);
  }
}
