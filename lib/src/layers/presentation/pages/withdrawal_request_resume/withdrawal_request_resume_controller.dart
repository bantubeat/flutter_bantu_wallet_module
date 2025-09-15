part of 'withdrawal_request_resume_page.dart';

class _WithdrawalRequestResumeController extends ScreenController {
  final CreateWithdrawalRequest param;

  PaymentPreferenceEntity? paymentPrefs;

  _WithdrawalRequestResumeController(super.state, this.param);

  void onSubmit() async {
    // Requst OTP code, then
  }
}
