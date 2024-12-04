import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.uuid,
    required super.nom,
    required super.prenom,
    required super.email,
    required super.pays,
    required super.createdAt,
    required super.updatedAt,
    required super.username,
    required super.slug,
    required super.telephone,
    required super.birthyear,
    required super.noms,
    required super.photoUrl,
    required super.profilBannerUrl,
    super.city,
    super.whatsapp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      uuid: json['uuid'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      pays: json['pays'],
      username: json['username'],
      slug: json['slug'],
      telephone: json['telephone'],
      city: json['city'],
      whatsapp: json['whatsapp'],
      birthyear: json['birthyear'],
      noms: json['noms'],
      photoUrl: json['photo_url'],
      profilBannerUrl: json['profil_banner_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'pays': pays,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'username': username,
      'slug': slug,
      'telephone': telephone,
      'city': city,
      'whatsapp': whatsapp,
      'birthyear': birthyear,
      'noms': noms,
      'photo_url': photoUrl,
      'profil_banner_url': profilBannerUrl,
    };
  }
}
