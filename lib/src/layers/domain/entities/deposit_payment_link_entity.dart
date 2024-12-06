import 'package:equatable/equatable.dart';

class DepositPaymentLinkEntity extends Equatable {
  final String paymentUrl;
  final String paymentRef;

  const DepositPaymentLinkEntity({
    required this.paymentUrl,
    required this.paymentRef,
  });

  @override
  List<Object?> get props => [paymentUrl, paymentRef];
}
