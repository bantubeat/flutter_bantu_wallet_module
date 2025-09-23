part of 'withdrawal_request_resume_page.dart';

class _WithdrawalRequestResumeController extends ScreenController {
  final CreateWithdrawalRequest createWithdrawalRequest;

  PaymentPreferenceEntity? paymentPrefs;
  bool isProcessing = false;

  _WithdrawalRequestResumeController(super.state, this.createWithdrawalRequest);

  String fullName = '...';
  String countryName = '...';

  @override
  void onReady() {
    final currentUserCubit = Modular.get<CurrentUserCubit>();
    if (currentUserCubit.state.hasData) {
      _initNameAndCountry(currentUserCubit.state.requireData);
    } else {
      currentUserCubit.stream.firstWhere((s) => s.hasData).then((state) {
        _initNameAndCountry(state.requireData);
      });
      currentUserCubit.fetchCurrentUser();
    }
  }

  @protected
  void _initNameAndCountry(UserEntity currentUser) {
    final paymentPreference = createWithdrawalRequest.paymentPreference;
    fullName = (paymentPreference.detailName?.isNotEmpty ?? false)
        ? paymentPreference.detailName!
        : '${currentUser.nom} ${currentUser.prenom}';
    countryName = CountryCode.tryFromCountryCode(currentUser.pays)?.name ?? '';
    refreshUI();
  }

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
        handleSubmit: _hanldeSubmitOTP,
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

  @protected
  Future<void> _hanldeSubmitOTP(BuildContext context, String code) async {
    EWithdrawalResponseStatus? status;
    var message = '';
    try {
      status = await Modular.get<RequestWithdrawalUseCase>().call(
        createWithdrawalRequest.copyWith(otpCode: code),
      );
    } catch (e, s) {
      debugPrint('Request withdrawal error: ${e.toString()}');
      debugPrintStack(label: e.toString(), stackTrace: s);
      message = e.toString();
      status = null;
    }

    switch (status) {
      case EWithdrawalResponseStatus.successfullyCreated:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_successfullyCreated
            .tr();

        break;
      case EWithdrawalResponseStatus.badOrExpiredPaymentSlip:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_badOrExpiredPaymentSlip
            .tr();
        break;

      case EWithdrawalResponseStatus.kycNotValidated:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_kycNotValidated
            .tr();
        break;
      case EWithdrawalResponseStatus.paymentPreferenceNotFound:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_paymentPreferenceNotFound
            .tr();
        break;
      case EWithdrawalResponseStatus.insufficientBalance:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_insufficientBalance
            .tr();
        break;
      case EWithdrawalResponseStatus.requestConflict:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_requestConflict
            .tr();
        break;
      case EWithdrawalResponseStatus.badOrExpiredOTPCode:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_badOrExpiredOTPCode
            .tr();
        break;
      case EWithdrawalResponseStatus.invalidRequestPeriod:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_invalidRequestPeriod
            .tr();
        break;
      case EWithdrawalResponseStatus.unknownError:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_unknownError
            .tr();
        break;
      case null:
        message = LocaleKeys.wallet_module_common_an_error_occur.tr(
          namedArgs: {
            'message': message,
          },
        );
        break;
    }

    if (status == EWithdrawalResponseStatus.successfullyCreated) {
      try {
        await Modular.get<UserBalanceCubit>().fetchUserBalance();
      } catch (e, s) {
        debugPrint('Refresh balance error: ${e.toString()}');
        debugPrintStack(label: e.toString(), stackTrace: s);
      }
    }

    if (!context.mounted) return;
    if (status == EWithdrawalResponseStatus.successfullyCreated) {
      Navigator.pop(context);
      UiAlertHelpers.showSuccessSnackBar(context, message);
      Modular.get<WalletRoutes>().home.navigate();
    } else {
      UiAlertHelpers.showErrorSnackBar(context, message);
    }
  }
}
