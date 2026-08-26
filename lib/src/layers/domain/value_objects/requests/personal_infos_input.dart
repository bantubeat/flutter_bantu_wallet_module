/// Payload for saving the current user's personal informations
/// (POST /account/personal-infos).
class PersonalInfosInput {
  final String prenom;
  final String nom;
  final String birthdate;
  final String gender;
  final String countryIso2;
  final String cityName;
  final String postalCode;
  final String neighborhood;
  final String street;

  const PersonalInfosInput({
    required this.prenom,
    required this.nom,
    required this.birthdate,
    required this.gender,
    required this.countryIso2,
    required this.cityName,
    required this.postalCode,
    required this.neighborhood,
    required this.street,
  });

  Map<String, dynamic> toJson() {
    return {
      'prenom': prenom,
      'nom': nom,
      'birthdate': birthdate,
      'gender': gender,
      'country_iso2': countryIso2,
      'city_name': cityName,
      'postal_code': postalCode,
      'neighborhood': neighborhood,
      'street': street,
    };
  }
}
