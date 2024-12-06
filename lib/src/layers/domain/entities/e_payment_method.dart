enum EPaymentMethod {
  flutterwave('Flutterwave'),
  stripe('Stripe'),
  paypal('Paypal');

  final String value;
  const EPaymentMethod(this.value);

  EPaymentMethod fromString(String value) {
    return values
        .singleWhere((e) => e.value.toLowerCase() == value.toLowerCase());
  }
}
