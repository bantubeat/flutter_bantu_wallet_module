import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/my_http/my_http_exceptions.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/financial_transaction_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/deposit/make_deposit_direct_payment_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/deposit/controller/payment_mixins/pay_with_google.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';

class _Host with PayWithGoogle {}

class _FakeMakeDepositDirectPaymentUseCase
    implements MakeDepositDirectPaymentUseCase {
  Future<FinancialTransactionEntity> Function() handler =
      () => throw UnimplementedError();
  int calls = 0;

  @override
  Future<FinancialTransactionEntity> call(params) {
    calls++;
    return handler();
  }
}

class _FakeTx extends FinancialTransactionEntity {
  _FakeTx(EFinancialTxStatus status)
      : super(
          id: 1,
          userId: 1,
          type: EFinancialTxType.deposit,
          oldBalance: 0,
          newBalance: 0,
          amount: 10,
          inputAmount: 10,
          inputCurrency: 'EUR',
          paymentMethod: 'stripe',
          status: status,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          uuid: 'uuid',
          paymentRef: 'ref',
        );
}

class _TestModule extends Module {
  final MakeDepositDirectPaymentUseCase useCase;

  _TestModule(this.useCase);

  @override
  void binds(Injector i) {
    i.addInstance<MakeDepositDirectPaymentUseCase>(useCase);
  }
}

Map<String, dynamic> _googlePayResult({Object? token = '{"id":"tok_123"}'}) => {
      'paymentMethodData': {
        'tokenizationData': {'token': token},
      },
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Without localization loaded, tr() returns the key itself.
  const launchFailed =
      LocaleKeys.wallet_module_deposit_page_google_pay_launch_failed;
  const refused =
      LocaleKeys.wallet_module_deposit_page_google_pay_payment_refused;

  final host = _Host();
  final useCase = _FakeMakeDepositDirectPaymentUseCase();
  final toasts = <String>[];

  setUpAll(() => Modular.bindModule(_TestModule(useCase)));

  setUp(() {
    toasts.clear();
    useCase.calls = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      (call) async {
        if (call.method == 'showToast') toasts.add(call.arguments['msg']);
        return true;
      },
    );
  });

  Future<void> pay(Map<String, dynamic>? result) =>
      host.onGooglePayResult(result, amount: 10, currency: 'EUR');

  test('null result (cancelled) shows nothing', () async {
    await pay(null);
    expect(toasts, isEmpty);
    expect(useCase.calls, 0);
  });

  group('incomplete Google Pay response shows launch error', () {
    test('without paymentMethodData', () async {
      await pay({});
      expect(toasts, [launchFailed]);
      expect(useCase.calls, 0);
    });

    test('without tokenizationData', () async {
      await pay({'paymentMethodData': <String, dynamic>{}});
      expect(toasts, [launchFailed]);
      expect(useCase.calls, 0);
    });

    test('without token', () async {
      await pay(_googlePayResult(token: null));
      expect(toasts, [launchFailed]);
      expect(useCase.calls, 0);
    });
  });

  group('use case failure shows refused message', () {
    test('with the server message when readable', () async {
      useCase.handler = () => throw const MyHttpBadRequestException(
            message: "Your card's security code is incorrect.",
          );
      await pay(_googlePayResult());
      expect(toasts, ["$refused\nYour card's security code is incorrect."]);
    });

    test('alone when the server message is empty', () async {
      useCase.handler =
          () => throw const MyHttpBadRequestException(message: '  ');
      await pay(_googlePayResult());
      expect(toasts, [refused]);
    });

    test('alone for a non HTTP error', () async {
      useCase.handler = () => throw Exception('boom');
      await pay(_googlePayResult());
      expect(toasts, [refused]);
    });
  });

  test('transaction not successful shows refused message', () async {
    for (final status in [
      EFinancialTxStatus.failed,
      EFinancialTxStatus.pending,
    ]) {
      toasts.clear();
      useCase.handler = () async => _FakeTx(status);
      await pay(_googlePayResult());
      expect(toasts, [refused], reason: status.name);
    }
  });
}
