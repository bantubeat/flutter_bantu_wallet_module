import '../../domain/entities/deposit_payment_link_entity.dart';

class DepositPaymentLinkModel extends DepositPaymentLinkEntity {
  const DepositPaymentLinkModel({
    required super.paymentUrl,
    required super.paymentRef,
  });

  factory DepositPaymentLinkModel.fromJson(Map<String, dynamic> json) {
    return DepositPaymentLinkModel(
      paymentUrl: json['payment_url'],
      paymentRef: json['payment_ref'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_url': paymentUrl,
      'payment_ref': paymentRef,
    };
  }
}
