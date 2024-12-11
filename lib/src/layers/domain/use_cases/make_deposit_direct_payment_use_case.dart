import '../../../core/use_cases/use_case.dart';
import '../entities/financial_transaction_entity.dart';
import '../repositories/payment_repository.dart';
import '../entities/e_payment_method.dart';

class MakeDepositDirectPaymentUseCase
    extends UseCase<FinancialTransactionEntity, _Param> {
  final PaymentRepository _repository;

  const MakeDepositDirectPaymentUseCase(this._repository);
  @override
  Future<FinancialTransactionEntity> call(params) {
    return _repository.makeDepositDirectPayment(
      paymentMethod: params.paymentMethod,
      amount: params.amount,
      currency: params.currency,
      stripeToken: params.stripeToken,
    );
  }
}

typedef _Param = ({
  EPaymentMethod paymentMethod,
  double amount,
  String? currency,
  String? stripeToken,
});
