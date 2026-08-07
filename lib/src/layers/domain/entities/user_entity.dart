import 'package:equatable/equatable.dart';
import '../../../core/config/countries.dart';

class MonetaryZone extends Equatable {
  final int id;
  final String name;
  final String currencyIso;
  final String currencyName;
  final String currencySymbol;

  const MonetaryZone({
    required this.id,
    required this.name,
    required this.currencyIso,
    required this.currencyName,
    required this.currencySymbol,
  });

  factory MonetaryZone.fromJson(Map<String, dynamic> json) {
    return MonetaryZone(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      currencyIso: json['currency_iso'] ?? '',
      currencyName: json['currency_name'] ?? '',
      currencySymbol: json['currency_symbol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currency_iso': currencyIso,
      'currency_name': currencyName,
      'currency_symbol': currencySymbol,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        currencyIso,
        currencyName,
        currencySymbol,
      ];
}

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
  final MonetaryZone? monetaryZone; // Nouveau champ

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
    this.monetaryZone, // Nouveau paramètre
  });

  bool get isAfrican => africanCountryCurrencyList
      .map((e) => e.iso2)
      .contains(pays.toUpperCase());

  // Getter pour accéder facilement aux infos de la zone monétaire
  String get currencySymbol => monetaryZone?.currencySymbol ?? 'F CFA';
  String get currencyCode => monetaryZone?.currencyIso ?? 'XAF';
  String get monetaryZoneName => monetaryZone?.name ?? '';

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
        monetaryZone, // Ajouté aux props
      ];
}
