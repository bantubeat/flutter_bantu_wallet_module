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
