import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../domain/entities/e_payment_method.dart';
import '../../../../../domain/use_cases/request_deposit_payment_link_use_case.dart';

mixin PayWithBantubeat {
  void payWithBantubeat(
    BuildContext context,
    EPaymentMethod paymentMethod,
    double amount, [
    String? currency,
  ]) async {
    final result = await Modular.get<RequestDepositPaymentLinkUseCase>().call(
      (
        paymentMethod: paymentMethod,
        amount: amount,
        currency: currency,
      ),
    );

    launchUrlString(result.paymentUrl, mode: LaunchMode.inAppWebView);
  }
}
