/// Payload for updating the current user's profile (PUT /account/user).
class UpdateUserProfileInput {
  final String nom;
  final String prenom;
  final String birthyear;
  final String city;
  final String pays;

  const UpdateUserProfileInput({
    required this.nom,
    required this.prenom,
    required this.birthyear,
    required this.city,
    required this.pays,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'birthyear': birthyear,
      'city': city,
      'pays': pays,
    };
  }
}
