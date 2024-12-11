import 'my_app_env.dart';

final class MyApiKeys {
  MyApiKeys._();

  static const flutterwavePublicKey = MyAppEnv.isProduction
      ? 'FLWPUBK-84e79c59e8ad25b6cd46689bcf36c587-X'
      : 'FLWPUBK_TEST-684d83a5080849a2d258f34dd032848c-X';

  static const paypalClientID = MyAppEnv.isProduction
      ? 'AbQYoTQK5JQoy5R8JH--O9c_2bZj0TG0jHSxWZO-h0mdkt4BaWPo0h2QfdxPWFcf4j334SCbTWfD50di'
      : 'AQ72LCTjBCYG-TNNywDJStZcS7f6w03r-TZsHk18PrwWEm9D3l2sP3TzjVV7ur2Sx9Fy_dkZvv3SYLwm';

  static const stripePublishableKey = MyAppEnv.isProduction
      ? 'pk_live_51Ia7fcCOHlg9HRJptRSOs0EemTxPzCKSnQiHSCq3hjYmn3cfslEY8RJuY4mc0CrT6Edw25XbKaGav1CTZJdCEAPm00ZNwHxqQh'
      : 'pk_test_51Ia7fcCOHlg9HRJpDfJbFOKWIWiutvaZ7IvJ6C7b4SmTmMu9rhUMlD7FEGaTjNlryUx76PB12m0F37xTJtlrq17800E7T0wPZU';
}
