import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/payment_web_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parsePaymentCompletedUrl', () {
    test('extracts a valid uuid', () {
      final result = parsePaymentCompletedUrl(
        'https://api.bantubeat.com/api/deposit-payment/completed/'
        '3f2b9c1e-8a4d-4e5f-9b6a-1c2d3e4f5a6b',
      );
      expect(result, isNotNull);
      expect(result!.uuid, '3f2b9c1e-8a4d-4e5f-9b6a-1c2d3e4f5a6b');
    });

    test('ignores query string and trailing slash', () {
      final result = parsePaymentCompletedUrl(
        'https://api.bantubeat.com/api/deposit-payment/completed/abc-123/?status=ok',
      );
      expect(result?.uuid, 'abc-123');
    });

    test('returns a null uuid for "unknown"', () {
      final result = parsePaymentCompletedUrl(
        'https://api.bantubeat.com/api/deposit-payment/completed/unknown',
      );
      expect(result, isNotNull);
      expect(result!.uuid, isNull);
    });

    test('returns a null uuid when the segment is empty', () {
      final result = parsePaymentCompletedUrl(
        'https://api.bantubeat.com/api/deposit-payment/completed/',
      );
      expect(result, isNotNull);
      expect(result!.uuid, isNull);
    });

    test('returns null for unrelated URLs', () {
      expect(
        parsePaymentCompletedUrl('https://checkout.stripe.com/pay/cs_test_123'),
        isNull,
      );
      expect(
        parsePaymentCompletedUrl('https://www.bantubeat.com/auth/login'),
        isNull,
      );
      expect(
        parsePaymentCompletedUrl(
          'https://example.com/?next=/deposit-payment/completed/abc',
        ),
        isNull,
      );
    });
  });
}
