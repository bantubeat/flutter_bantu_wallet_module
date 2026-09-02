import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/my_http/my_http.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/withdrawal_simulation_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/request_withdrawal_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/create_withdrawal_request.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/user_balance_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/navigation/wallet_routes.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/generate_withdrawal_payment_slip_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/send_withdrawal_mail_otp_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_withdrawal_response_status.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/pdf_printer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import 'widgets/otp_result_screen.dart';
import 'widgets/otp_verification_screen.dart';

class BordereauPage extends StatefulWidget {
  final WithdrawalSimulationEntity simulation;
  final PaymentPreferenceEntity paymentPreference;

  const BordereauPage(this.simulation, this.paymentPreference, {super.key});

  @override
  State<BordereauPage> createState() => _BordereauPageState();
}

class _BordereauPageState extends State<BordereauPage> {
  bool _accepted = false;
  bool _isProcessing = false;
  bool _isGeneratingPdf = false;

  static const Color darkColor = Colors.black;

  WithdrawalSimulationEntity get simulation => widget.simulation;
  bool get isMobileMoney => simulation.payoutType == 'mobile_money';
  double get montant => (simulation.calculation?.grossAmount ?? 0).toDouble();

  String _reference() =>
      simulation.paymentReferenceInfo?.full ?? simulation.paymentReference;

  String _operator() {
    final d = widget.paymentPreference;
    return d.detailOperator ??
        simulation.paymentPreference?.details?.detailOperator ??
        '';
  }

  String _account() {
    final d = widget.paymentPreference;
    return d.detailPhone ?? d.detailIban ?? '';
  }

  String _bank() {
    final d = widget.paymentPreference;
    return d.detailBankName ?? '';
  }

  String formatMontant(double value) {
    return NumberFormat('#,##0', 'fr_FR')
        .format(value)
        .replaceAll(',', '\u00a0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    _buildIcon(),
                    const SizedBox(height: 20),
                    _buildTitle(),
                    const SizedBox(height: 10),
                    _buildSubtitle(),
                    const SizedBox(height: 24),
                    _buildInfoCard(),
                    const SizedBox(height: 24),
                    _buildEngagementSection(),
                    const SizedBox(height: 24),
                    _buildConfirmButton(),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Modular.get<WalletRoutes>()
                              .verifiePaiementAccount
                              .push(widget.paymentPreference);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE7E9E8),
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          LocaleKeys
                              .wallet_module_withdrawal_process_bordereau_modify_coordinates
                              .tr(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFooter(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- App bar ----
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: darkColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Text(
            LocaleKeys.wallet_module_withdrawal_process_bordereau_appbar.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          BlocBuilder<CurrentUserCubit, AsyncSnapshot>(
            bloc: Modular.get<CurrentUserCubit>(),
            builder: (context, snap) {
              final user = snap.data;
              final name = user?.noms ?? '';
              final initials = name.isNotEmpty
                  ? name
                      .split(' ')
                      .map((w) => w.isNotEmpty ? w[0] : '')
                      .take(2)
                      .join()
                  : '?';
              return CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Text(
                  initials.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFE7E9E8),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.account_balance_outlined,
        color: Colors.black87,
        size: 26,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      isMobileMoney
          ? LocaleKeys
              .wallet_module_withdrawal_process_bordereau_title_mobile
              .tr()
          : LocaleKeys.wallet_module_withdrawal_process_bordereau_title_bank
              .tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      LocaleKeys
          .wallet_module_withdrawal_process_bordereau_verify_info_before_confirm
          .tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
        height: 1.4,
      ),
    );
  }

  // ---- Carte info ----
  Widget _buildInfoCard() {
    final calc = simulation.calculation;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys
                .wallet_module_withdrawal_process_bordereau_document_status
                .tr(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE7E9E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              simulation.status.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.wallet_module_withdrawal_process_bordereau_reference
                .tr(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _reference(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  LocaleKeys
                      .wallet_module_withdrawal_process_bordereau_amount_to_transfer
                      .tr(),
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: formatMontant(montant),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: ' XAF',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Divider(color: Colors.grey.shade300, height: 1),
                const SizedBox(height: 16),
                if (calc != null) ...[
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_gross_amount
                        .tr(),
                    '${formatMontant(calc.grossAmount.toDouble())} XAF',
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_platform_fee
                        .tr(namedArgs: {'pct': _pct(calc.feePlatformPct)}),
                    '- ${formatMontant(calc.feePlatform.toDouble())} XAF',
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_operator_fee
                        .tr(namedArgs: {'pct': _pct(calc.feeOperatorPct)}),
                    '- ${formatMontant(calc.feeOperator.toDouble())} XAF',
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys.wallet_module_withdrawal_process_bordereau_taxes
                        .tr(namedArgs: {'pct': _pct(calc.taxPct)}),
                    '- ${formatMontant(calc.tax.toDouble())} XAF',
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_total_fees
                        .tr(),
                    '- ${formatMontant(calc.totalFees.toDouble())} XAF',
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_net_to_receive
                        .tr(),
                    '${formatMontant(calc.netAmount.toDouble())} XAF',
                  ),
                  const SizedBox(height: 18),
                  Divider(color: Colors.grey.shade300, height: 1),
                  const SizedBox(height: 16),
                ],
                if (isMobileMoney) ...[
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_operator
                        .tr(),
                    _operator(),
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_account_number
                        .tr(),
                    _account(),
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_transfer_type
                        .tr(),
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_mobile_money
                        .tr(),
                  ),
                ] else ...[
                  _infoRow(
                    LocaleKeys.wallet_module_withdrawal_process_bordereau_bank
                        .tr(),
                    _bank(),
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys.wallet_module_common_iban.tr(),
                    _account(),
                  ),
                  const SizedBox(height: 14),
                  _infoRow(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_transfer_type
                        .tr(),
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_bank_transfer
                        .tr(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _pct(num value) => '${value.toStringAsFixed(1)}%';

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // ---- Engagement légal ----
  Widget _buildEngagementSection() {
    final text = isMobileMoney
        ? LocaleKeys
            .wallet_module_withdrawal_process_bordereau_engagement_mobile
            .tr(namedArgs: {'account': _account()})
        : LocaleKeys
            .wallet_module_withdrawal_process_bordereau_engagement_bank
            .tr(namedArgs: {'account': _account()});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys
              .wallet_module_withdrawal_process_bordereau_legal_engagement
              .tr(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: darkColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () => setState(() => _accepted = !_accepted),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioGroup<bool>(
                            groupValue: _accepted ? true : null,
                            onChanged: (_) =>
                                setState(() => _accepted = !_accepted),
                            child: const Radio<bool>(
                              value: true,
                              activeColor: darkColor,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                LocaleKeys
                                    .wallet_module_withdrawal_process_bordereau_confirm_agreement
                                    .tr(),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---- Boutons ----
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_accepted && !_isProcessing) ? _onConfirm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColor,
          disabledBackgroundColor: darkColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys
                        .wallet_module_withdrawal_process_bordereau_confirm_and_send
                        .tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Icon(
          Icons.verified_user_outlined,
          color: Colors.grey.shade400,
          size: 22,
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys
              .wallet_module_withdrawal_process_bordereau_secure_transaction_aes
              .tr(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Future<void> _printPdf() async {
    if (_isGeneratingPdf) return;
    setState(() => _isGeneratingPdf = true);
    try {
      final calc = simulation.calculation;
      await printDetailsPdf(
        title: LocaleKeys
            .wallet_module_withdrawal_process_bordereau_pdf_title
            .tr(namedArgs: {'reference': _reference()}),
        details: {
          LocaleKeys.wallet_module_withdrawal_process_bordereau_reference
              .tr(): _reference(),
          LocaleKeys.wallet_module_withdrawal_process_bordereau_pdf_status
              .tr(): simulation.status,
          if (isMobileMoney)
            LocaleKeys.wallet_module_withdrawal_process_bordereau_operator
                .tr(): _operator(),
          if (isMobileMoney)
            LocaleKeys
                .wallet_module_withdrawal_process_bordereau_account_number
                .tr(): _account(),
          if (!isMobileMoney)
            LocaleKeys.wallet_module_withdrawal_process_bordereau_bank
                .tr(): _bank(),
          if (!isMobileMoney)
            LocaleKeys.wallet_module_common_iban.tr(): _account(),
          LocaleKeys.wallet_module_withdrawal_process_bordereau_transfer_type
              .tr(): isMobileMoney
              ? LocaleKeys
                  .wallet_module_withdrawal_process_bordereau_mobile_money
                  .tr()
              : LocaleKeys
                  .wallet_module_withdrawal_process_bordereau_bank_transfer
                  .tr(),
          LocaleKeys.wallet_module_withdrawal_process_bordereau_gross_amount
              .tr(): '${formatMontant(montant)} XAF',
          if (calc != null)
            LocaleKeys.wallet_module_withdrawal_process_bordereau_platform_fee
                .tr(namedArgs: {'pct': _pct(calc.feePlatformPct)}):
                '- ${formatMontant(calc.feePlatform.toDouble())} XAF',
          if (calc != null)
            LocaleKeys.wallet_module_withdrawal_process_bordereau_operator_fee
                .tr(namedArgs: {'pct': _pct(calc.feeOperatorPct)}):
                '- ${formatMontant(calc.feeOperator.toDouble())} XAF',
          if (calc != null)
            LocaleKeys.wallet_module_withdrawal_process_bordereau_taxes
                .tr(namedArgs: {'pct': _pct(calc.taxPct)}):
                '- ${formatMontant(calc.tax.toDouble())} XAF',
          if (calc != null)
            LocaleKeys.wallet_module_withdrawal_process_bordereau_total_fees
                .tr():
                '- ${formatMontant(calc.totalFees.toDouble())} XAF',
          if (calc != null)
            LocaleKeys.wallet_module_withdrawal_process_bordereau_net_to_receive
                .tr():
                '${formatMontant(calc.netAmount.toDouble())} XAF',
        },
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _onConfirm() async {
    setState(() => _isProcessing = true);
    try {
      await Modular.get<SendWithdrawalMailOtpUseCase>().call(NoParms());

      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => OtpValidationScreen(
            accountName: _account(),
            onSubmit: (code) => _handleSubmitOTP(code),
            onResendCode: () async {
              await Modular.get<SendWithdrawalMailOtpUseCase>().call(NoParms());
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is MyHttpClientSideException
          ? (e.message ?? e.toString())
          : e.toString();
      UiAlertHelpers.showErrorToast(message);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleSubmitOTP(String code) async {
    EWithdrawalResponseStatus? status;
    var message = '';
    try {
      final slip = await Modular.get<GenerateWithdrawalPaymentSlipUseCase>()
          .call(NoParms());

      final balanceCubit = Modular.get<UserBalanceCubit>();
      final balance = balanceCubit.state.data;
      final financialAccountId = balance?.financialWalletNumber ?? '';

      final param = CreateWithdrawalRequest(
        otpCode: code,
        paymentSlip: slip,
        amount: montant,
        paymentPreference: widget.paymentPreference,
        financialAccountId: financialAccountId,
        paymentReference: widget.simulation.paymentReference,
      );

      status = await Modular.get<RequestWithdrawalUseCase>().call(param);
    } catch (e) {
      message = e.toString();
      status = null;
    }

    switch (status) {
      case EWithdrawalResponseStatus.successfullyCreated:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_successfullyCreated
            .tr();
        break;
      case EWithdrawalResponseStatus.insufficientBalance:
        message =
            LocaleKeys.wallet_module_withdrawal_process_status_insufficientBalance
                .tr();
        break;
      case EWithdrawalResponseStatus.badOrExpiredOTPCode:
        message =
            LocaleKeys.wallet_module_withdrawal_process_status_badOrExpiredOTPCode
                .tr();
        break;
      case EWithdrawalResponseStatus.kycNotValidated:
        message =
            LocaleKeys.wallet_module_withdrawal_process_status_kycNotValidated
                .tr();
        break;
      case EWithdrawalResponseStatus.paymentPreferenceNotFound:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_paymentPreferenceNotFound
            .tr();
        break;
      case EWithdrawalResponseStatus.requestConflict:
        message =
            LocaleKeys.wallet_module_withdrawal_process_status_requestConflict
                .tr();
        break;
      case EWithdrawalResponseStatus.invalidRequestPeriod:
        message =
            LocaleKeys.wallet_module_withdrawal_process_status_invalidRequestPeriod
                .tr();
        break;
      case EWithdrawalResponseStatus.badOrExpiredPaymentSlip:
        message = LocaleKeys
            .wallet_module_withdrawal_process_status_badOrExpiredPaymentSlip
            .tr();
        break;
      case EWithdrawalResponseStatus.unknownError:
        message = LocaleKeys.wallet_module_withdrawal_process_status_unknownError
            .tr();
        break;
      case null:
        message =
            LocaleKeys.wallet_module_common_an_error_occur
                .tr(namedArgs: {'message': message});
        break;
    }

    if (!mounted) return;

    if (status == EWithdrawalResponseStatus.successfullyCreated) {
      try {
        await Modular.get<UserBalanceCubit>().fetchUserBalance();
      } catch (_) {}
      if (!mounted) return;
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute(
          builder: (_) => TransactionResultScreen(
            success: true,
            headerTitle: LocaleKeys.wallet_module_withdrawal_page_title.tr(),
            title: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_withdrawal_created
                .tr(),
            message: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_withdrawal_success_message
                .tr(namedArgs: {'amount': formatMontant(montant)}),
            infoText: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_processing_time
                .tr(),
            infoHighlight: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_processing_time_desc
                .tr(),
            infoTextSuffix: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_processing_time_suffix
                .tr(),
            primaryLabel: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_back_home
                .tr(),
            onPrimaryPressed: () {
              Modular.get<WalletRoutes>().home.navigate();
            },
            secondaryLabel: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_download_slip_pdf
                .tr(),
            onSecondaryPressed: _printPdf,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute(
          builder: (_) => TransactionResultScreen(
            success: false,
            headerTitle: LocaleKeys.wallet_module_withdrawal_page_title.tr(),
            title: LocaleKeys
                .wallet_module_withdrawal_process_bordereau_withdrawal_failed
                .tr(),
            message: message,
            primaryLabel: LocaleKeys.wallet_module_common_try_again.tr(),
            onPrimaryPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }
}
