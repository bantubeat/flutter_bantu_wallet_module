enum EAccountType {
  mobile('Mobile'),
  bankTransfer('BankTransfer'),
  paypal('Paypal');

  final String value;

  const EAccountType(this.value);

  factory EAccountType.fromString(String value) {
    return EAccountType.values.firstWhere((e) => e.value == value);
  }

  @override
  String toString() => value;
}

enum AccountType {
  payment,
  revenue,
  bzc;

  /// Libellé lisible pour l'affichage
  String get label {
    switch (this) {
      case AccountType.payment:
        return 'Paiement';
      case AccountType.revenue:
        return 'Revenu';
      case AccountType.bzc:
        return 'BZC';
    }
  }

  /// Conversion depuis une chaîne (utile pour Firestore, API, etc.)
  static AccountType fromString(String value) {
    return AccountType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Type de compte inconnu: $value'),
    );
  }
}
