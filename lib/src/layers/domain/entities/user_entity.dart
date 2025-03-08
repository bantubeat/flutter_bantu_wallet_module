import 'package:equatable/equatable.dart';

import '../../../core/config/countries.dart';

class UserEntity extends Equatable {
  final int id;
  final String uuid;
  final String slug;
  final String username;
  final String noms;
  final String? nom;
  final String? prenom;
  final String? photoUrl;
  final String? profilBannerUrl;
  final int birthyear;
  final String email;
  final String pays;
  final String? telephone;
  final String? city;
  final String? whatsapp;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.uuid,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.pays,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.slug,
    required this.telephone,
    required this.birthyear,
    required this.noms,
    required this.photoUrl,
    required this.profilBannerUrl,
    this.city,
    this.whatsapp,
  });

  bool get isAfrican => africanCountryCurrencyList
      .map((e) => e.iso2)
      .contains(pays.toUpperCase());

  @override
  List<Object?> get props => [
        id,
        uuid,
        nom,
        prenom,
        email,
        pays,
        createdAt,
        updatedAt,
        username,
        slug,
        telephone,
        city,
        whatsapp,
        birthyear,
        noms,
        photoUrl,
        profilBannerUrl,
      ];
}
