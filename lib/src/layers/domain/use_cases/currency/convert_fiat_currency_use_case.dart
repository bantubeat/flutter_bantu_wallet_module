import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/public_repository.dart';

class ConvertFiatCurrencyUseCase extends UseCase<double, _Param> {
  final PublicRepository _repository;

  ConvertFiatCurrencyUseCase(this._repository);

  @override
  Future<double> call(params) async {
    final amount = params.amount;
    final fromCurr = params.fromCurr;
    final toCurr = params.toCurr;

    if (fromCurr == toCurr) return amount;

    try {
      final rates = await _repository.getAllCurrencies();

      final from = rates.singleWhere(
        (item) => item.code.toUpperCase() == fromCurr.toUpperCase(),
      );

      final to = rates.singleWhere(
        (item) => item.code.toUpperCase() == toCurr.toUpperCase(),
      );

      final amountInEur = amount / from.oneEurValue;

      return amountInEur * to.oneEurValue;
    } catch (e) {
      throw Exception('Failed to fetch rates ${e.toString()}');
    }
  }
}

typedef _Param = ({
  double amount,
  String fromCurr,
  String toCurr,
});
