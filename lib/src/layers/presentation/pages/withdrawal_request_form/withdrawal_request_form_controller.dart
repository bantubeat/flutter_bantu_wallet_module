part of 'withdrawal_request_form_page.dart';

class _WithdrawalRequestFormController extends ScreenController {
  final amountCtrl = TextEditingController(text: '');
  String? slip;
  bool isProcessing = false;
  var error = '';

  _WithdrawalRequestFormController(super.state);

  @override
  void onInit() {
    _generateSlip(refreshUI: true);
  }

  @protected
  Future<String> _generateSlip({bool refreshUI = false}) {
    return Modular.get<GenerateWithdrawalPaymentSlipUseCase>()
        .call(NoParms())
        .then((generatedSlip) {
      slip = generatedSlip;
      if (refreshUI) this.refreshUI();
      return generatedSlip;
    });
  }

  void onPrivatePolicy() {
    launchUrlString(
      ApiConstants.privacyPolicyUrl,
      mode: LaunchMode.externalApplication,
    );
  }

  @protected
  void _backToWithdrawalPage() {
    Modular.to.pushReplacementNamed(
      Modular.get<WalletRoutes>().withdrawal.toString(),
    );
  }

  void onSubmit() async {
    if (isProcessing) return;
    final amount = num.tryParse(amountCtrl.text);
    if (amount == null || amount < 0) {
      error = 'Le montant doit être un nombre positif';
      refreshUI();
      return;
    } else {
      error = '';
      refreshUI();
    }

    final balanceCubit = Modular.get<UserBalanceCubit>();
    late double balanceInEur;
    late String financialAccountId;

    if (balanceCubit.state.hasData) {
      balanceInEur = balanceCubit.state.requireData.eur;
      financialAccountId = balanceCubit.state.requireData.financialWalletNumber;
    } else {
      updateUI(() => isProcessing = true);
      final userBalance = await balanceCubit.fetchUserBalance();
      balanceInEur = userBalance.eur;
      financialAccountId = userBalance.financialWalletNumber;
      updateUI(() => isProcessing = false);
    }

    if (amount > balanceInEur) {
      error =
          LocaleKeys.wallet_module_withdrawal_process_insufficient_funds.tr();
      refreshUI();
      return;
    }

    final paymentPrefsList =
        await Modular.get<GetPaymentPreferencesUseCase>().call(NoParms());
    final paymentPrefs = paymentPrefsList.firstOrNull;
    if (paymentPrefs == null) {
      _backToWithdrawalPage();
      return;
    }

    final withdrawalEligibility =
        await Modular.get<CheckWithdrawalEligibilityUseCase>().call(NoParms());

    if (withdrawalEligibility != EWithdrawalEligibility.eligible) {
      UiAlertHelpers.showErrorToast(withdrawalEligibility.englishDescription);
      _backToWithdrawalPage();
      return;
      /*
      switch (withdrawalEligibility) {
        case EWithdrawalEligibility.alreadyMadeWithdrawal:
          _backToWithdrawalPage();
          break;
        case EWithdrawalEligibility.invalidRequestPeriod:
          _backToWithdrawalPage();
          break;
        case EWithdrawalEligibility.kycNotValidated:
          _backToWithdrawalPage();
          break;
        case EWithdrawalEligibility.pendingWithdrawal:
          _backToWithdrawalPage();
          break;
        case EWithdrawalEligibility.unknownError:
          _backToWithdrawalPage();
          break;
        default:
      } 
      return;
			*/
    }

    final param = CreateWithdrawalRequest(
      otpCode: '',
      paymentSlip: slip ?? await _generateSlip(),
      amount: amount,
      paymentPreference: paymentPrefs,
      financialAccountId: financialAccountId,
    );
    Modular.get<WalletRoutes>().withdrawalRequestResume.push(param);
  }
}
