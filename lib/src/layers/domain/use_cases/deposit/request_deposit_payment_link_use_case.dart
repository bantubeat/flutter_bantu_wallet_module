import '../../../../core/use_cases/use_case.dart';
import '../../repositories/payment_repository.dart';
import '../../entities/deposit_payment_link_entity.dart';
import '../../entities/enums/e_payment_method.dart';

class RequestDepositPaymentLinkUseCase
    extends UseCase<DepositPaymentLinkEntity, _Param> {
  final PaymentRepository _repository;

  const RequestDepositPaymentLinkUseCase(this._repository);
  @override
  Future<DepositPaymentLinkEntity> call(params) {
    return _repository.requestDepositPaymentLink(
      paymentMethod: params.paymentMethod,
      amount: params.amount,
      currency: params.currency,
    );
  }
}

typedef _Param = ({
  EPaymentMethod paymentMethod,
  double amount,
  String? currency,
});
