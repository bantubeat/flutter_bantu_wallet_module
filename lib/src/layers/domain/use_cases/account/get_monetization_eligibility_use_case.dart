import 'package:flutter_bantu_wallet_module/src/layers/data/models/eligible_country.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/repositories/public_repository.dart';

class GetMonetizationEligibilityUseCase {
  const GetMonetizationEligibilityUseCase(this._repository);
  final PublicRepository _repository;

  Future<bool> call(String countryCode) async {
    final res =
        await _repository.checkMonetizationEligibleCountries(countryCode);

    return res?.any((e) => e.countryCode == countryCode) ?? false;
  }

  Future<EligibleCountry?> get(String countryCode) async {
    final res =
        await _repository.checkMonetizationEligibleCountries(countryCode);

    return res?.where((e) => e.countryCode == countryCode).firstOrNull;
  }
}
