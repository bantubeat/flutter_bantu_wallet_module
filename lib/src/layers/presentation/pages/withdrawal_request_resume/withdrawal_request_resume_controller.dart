part of 'withdrawal_request_resume_page.dart';

class _WithdrawalRequestResumeController extends ScreenController {
  final CreateWithdrawalRequest createWithdrawalRequest;

  PaymentPreferenceEntity? paymentPrefs;
  bool isProcessing = false;

  _WithdrawalRequestResumeController(super.state, this.createWithdrawalRequest);

  void onSubmit() async {
    if (isProcessing) return;

    isProcessing = true;
    refreshUI();

    try {
      await Modular.get<SendWithdrawalMailOtpUseCase>().call(NoParms());

      if (!context.mounted) return;

      await OtpCodeModal(
        title: LocaleKeys.wallet_module_withdrawal_process_otp_code_title.tr(),
        description: LocaleKeys
            .wallet_module_withdrawal_process_otp_code_description
            .tr(),
        handleSubmit: (context, code) async {
          await Modular.get<RequestWithdrawalUseCase>().call(
            createWithdrawalRequest.copyWith(otpCode: code),
          );
          if (!context.mounted) return;
          Navigator.pop(context);
          Modular.get<WalletRoutes>().withdrawal.navigate();
        },
        handleResend: (context) {
          return Modular.get<SendWithdrawalMailOtpUseCase>().call(NoParms());
        },
      ).show(context);
    } catch (e) {
      if (!mounted) return;
      isProcessing = false;
      refreshUI();
    }
  }
}
