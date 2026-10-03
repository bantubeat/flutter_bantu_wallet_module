import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

/// Delegate des traductions de noms de pays fournies par le package
/// `country_code_picker` (assets `packages/country_code_picker/src/i18n/*.json`).
///
/// Instance unique : `Localizations` compare les delegates par identité pour
/// décider s'il doit recharger les ressources, une instance créée à chaque
/// build provoquerait un rechargement à chaque frame.
final LocalizationsDelegate<CountryLocalizations>
    _countryLocalizationsDelegate = CountryLocalizations.getDelegate();

/// Rend les noms de pays traduits disponibles pour [child], sans dépendre de la
/// configuration `localizationsDelegates` de l'application hôte.
class LocalizedCountryScope extends StatelessWidget {
  const LocalizedCountryScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      delegates: <LocalizationsDelegate<dynamic>>[
        _countryLocalizationsDelegate,
      ],
      child: child,
    );
  }
}

/// Nom du pays dans la langue courante, à partir de son code ISO
/// (ex: `CM` -> `Cameroun` en français, `Cameroon` en anglais).
///
/// Repli sur le nom anglais du package si la locale courante n'est pas gérée
/// par `country_code_picker` ou si le delegate n'est pas installé.
String localizedCountryName(
  BuildContext context,
  String? isoCode, {
  String fallback = '--',
}) {
  final country = _countryFromCode(isoCode);
  if (country == null) return fallback;
  final translated = CountryLocalizations.of(context)?.translate(country.code);
  if (translated != null && translated.trim().isNotEmpty) return translated;
  return _nameOrFallback(country, fallback);
}

/// Nom du pays en anglais (valeur par défaut du package), pour les contextes
/// sans [BuildContext] (contrôleurs, modèles) ou pour la recherche.
String defaultCountryName(String? isoCode, {String fallback = ''}) {
  final country = _countryFromCode(isoCode);
  if (country == null) return fallback;
  return _nameOrFallback(country, fallback);
}

CountryCode? _countryFromCode(String? isoCode) {
  final code = isoCode?.trim();
  if (code == null || code.isEmpty) return null;
  return CountryCode.tryFromCountryCode(code.toUpperCase());
}

String _nameOrFallback(CountryCode country, String fallback) {
  final name = country.name?.trim();
  return (name == null || name.isEmpty) ? fallback : name;
}
