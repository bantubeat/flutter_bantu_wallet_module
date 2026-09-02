import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/my_http/my_http.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payout_configs_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/balance/get_payout_configs_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/check_withdrawal_eligibility_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_withdrawal_eligibility.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/simulate_withdrawal_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/get_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/user_balance_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/navigation/wallet_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import 'bordereau_args.dart';

class RetraitPage extends StatefulWidget {
  const RetraitPage({super.key});

  @override
  State<RetraitPage> createState() => _RetraitPageState();
}

class _RetraitPageState extends State<RetraitPage> {
  final TextEditingController _amountController = TextEditingController();

  static const Color darkColor = Colors.black;
  static const Color cardGrey = Color(0xFFE7E9E8);

  PayoutConfigsEntity? _payoutConfigs;
  PaymentPreferenceEntity? _paymentPreference;
  bool _isLoading = true;
  String? _error;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        Modular.get<GetPayoutConfigsUseCase>().call(NoParms()),
        Modular.get<GetPaymentPreferencesUseCase>().call(NoParms()),
      ]);
      if (!mounted) return;
      final configs = results[0] as PayoutConfigsEntity;
      final prefs = results[1] as List<PaymentPreferenceEntity>;
      setState(() {
        _payoutConfigs = configs;
        _paymentPreference = prefs.firstOrNull;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  bool get _isMobileMoney =>
      _paymentPreference?.accountType == EAccountType.mobile;

  MobileMoneyPayoutEntity? get _mobileMoney => _payoutConfigs?.mobileMoney;
  BankPayoutEntity? get _bank => _payoutConfigs?.bank;

  double get _feeFixedPct => _isMobileMoney
      ? (_mobileMoney?.feeFixedPct ?? 0)
      : (_bank?.feeFixedPct ?? 0);
  double get _feeOperatorPct => _isMobileMoney
      ? (_mobileMoney?.feeOperatorPct ?? 0)
      : (_bank?.feeOperatorPct ?? 0);
  double get _taxFixedPct => _isMobileMoney
      ? (_mobileMoney?.taxFixedPct ?? 0)
      : (_bank?.taxFixedPct ?? 0);
  double get _minWithdrawal => _isMobileMoney
      ? (_mobileMoney?.minWithdrawal ?? 0)
      : (_bank?.minWithdrawal ?? 0);
  double get _maxWithdrawal => _isMobileMoney
      ? (_mobileMoney?.maxWithdrawal ?? 0)
      : _mobileMoney?.maxDaily ?? 0;

  double get montantBrut {
    final text = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(text) ?? 0;
  }

  double get bnc => montantBrut * (_taxFixedPct / 100);
  double get fraisService => montantBrut * (_feeFixedPct / 100);
  double get fraisOperateur => montantBrut * (_feeOperatorPct / 100);
  double get netARecevoir => montantBrut - bnc - fraisService - fraisOperateur;

  bool get _isAmountValid {
    if (montantBrut <= 0) return false;
    if (montantBrut < _minWithdrawal) return false;
    if (_isMobileMoney && _maxWithdrawal > 0 && montantBrut > _maxWithdrawal) {
      return false;
    }
    return true;
  }

  String formatMontant(double value) {
    return NumberFormat('#,##0', 'fr_FR').format(value).replaceAll(',', ' ');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Visibility(
          visible: !_isLoading,
          replacement:
              const Center(child: CircularProgressIndicator.adaptive()),
          child: Visibility(
            visible: _error == null,
            replacement: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.wallet_module_withdrawal_process_load_error
                          .tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _error = null;
                        });
                        _loadData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkColor,
                      ),
                      child: Text(
                        LocaleKeys.wallet_module_common_try_again.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  color: darkColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        LocaleKeys.wallet_module_withdrawal_page_title.tr(),
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
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildSoldeCard(),
                        const SizedBox(height: 10),
                        _buildMinMaxText(),
                        const SizedBox(height: 24),
                        _buildMontantLabel(),
                        const SizedBox(height: 12),
                        _buildAmountField(),
                        const SizedBox(height: 8),
                        _buildMinMaxTextRed(),
                        const SizedBox(height: 28),
                        _buildDetailsLabel(),
                        const SizedBox(height: 12),
                        _buildDetailsCard(),
                        const SizedBox(height: 20),
                        _buildNetARecevoir(),
                        const SizedBox(height: 24),
                        _buildContinuerButton(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoldeCard() {
    return BlocBuilder<UserBalanceCubit, AsyncSnapshot<UserBalanceEntity>>(
      bloc: Modular.get<UserBalanceCubit>(),
      builder: (context, balanceSnap) {
        final balance = balanceSnap.data;
        final amount = balance?.revenueAccount?.userCurrencyBalance ??
            balance?.revenueUserCurrencyBalance ??
            balance?.userCurrencyBalance;
        final currencyCode = balance?.revenueAccount?.userCurrencyCode ??
            balance?.userCurrencyCode ??
            'XAF';
        final userName =
            Modular.get<CurrentUserCubit>().state.data?.username ?? '';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardGrey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.wallet_module_withdrawal_process_solde_disponible
                    .tr(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${amount != null ? formatMontant(amount) : '--'} ',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: currencyCode,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (userName.isNotEmpty) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 1.5,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMinMaxText() {
    final min = formatMontant(_minWithdrawal);
    final max = _isMobileMoney && _maxWithdrawal > 0
        ? formatMontant(_maxWithdrawal)
        : '--';
    return Text(
      LocaleKeys.wallet_module_withdrawal_process_minimum_maximum
          .tr(namedArgs: {'min': min, 'max': max}),
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildMinMaxTextRed() {
    if (montantBrut <= 0) return const SizedBox.shrink();
    if (montantBrut < _minWithdrawal) {
      return Text(
        LocaleKeys.wallet_module_withdrawal_process_minimum
            .tr(namedArgs: {'amount': formatMontant(_minWithdrawal)}),
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    if (_isMobileMoney && _maxWithdrawal > 0 && montantBrut > _maxWithdrawal) {
      return Text(
        LocaleKeys.wallet_module_withdrawal_process_maximum
            .tr(namedArgs: {'amount': formatMontant(_maxWithdrawal)}),
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMontantLabel() {
    return Text(
      LocaleKeys.wallet_module_withdrawal_process_amount_to_withdraw_label
          .tr(),
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: darkColor, width: 1.4),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.grey.shade300),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          const Text(
            'XAF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsLabel() {
    return Text(
      LocaleKeys.wallet_module_withdrawal_process_operation_details.tr(),
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.wallet_module_withdrawal_process_bordereau_gross_amount
                      .tr(),
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  '${formatMontant(montantBrut)} XAF',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: cardGrey,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              children: [
                _detailRow(
                  LocaleKeys.wallet_module_withdrawal_process_bnc.tr(
                    namedArgs: {'pct': _taxFixedPct.toStringAsFixed(1)},
                  ),
                  bnc,
                ),
                const SizedBox(height: 12),
                _detailRow(
                  LocaleKeys.wallet_module_withdrawal_process_service_fee.tr(
                    namedArgs: {'pct': _feeFixedPct.toStringAsFixed(1)},
                  ),
                  fraisService,
                ),
                const SizedBox(height: 12),
                _detailRow(
                  _isMobileMoney
                      ? LocaleKeys
                          .wallet_module_withdrawal_process_bordereau_operator_fee
                          .tr(
                            namedArgs: {
                              'pct': _feeOperatorPct.toStringAsFixed(1),
                            },
                          )
                      : LocaleKeys.wallet_module_withdrawal_process_bank_fee
                          .tr(
                            namedArgs: {
                              'pct': _feeOperatorPct.toStringAsFixed(1),
                            },
                          ),
                  fraisOperateur,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          '${formatMontant(value)} XAF',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNetARecevoir() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.wallet_module_withdrawal_process_net_to_receive_label
                .tr(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            '${formatMontant(netARecevoir)} XAF',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinuerButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_isAmountValid && !_isProcessing) ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColor,
          disabledBackgroundColor: Colors.grey.shade400,
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
            : Text(
                LocaleKeys.wallet_module_withdrawal_process_continue.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_isProcessing) return;
    final amount = montantBrut;
    final paymentPrefs = _paymentPreference;

    setState(() => _isProcessing = true);
    try {
      final withdrawalEligibility =
          await Modular.get<CheckWithdrawalEligibilityUseCase>()
              .call(NoParms());
      if (withdrawalEligibility != EWithdrawalEligibility.eligible) {
        if (mounted) {
          UiAlertHelpers.showErrorToast(
            withdrawalEligibility.englishDescription,
          );
        }
        return;
      }

      if (paymentPrefs == null) {
        if (mounted) {
          Modular.get<WalletRoutes>().addOrEditPaymentAccount.push();
        }
        return;
      }

      final simulation = await Modular.get<SimulateWithdrawalUseCase>().call(
        SimulateWithdrawalParams(
          amount: amount,
          paymentPreferenceUuid: paymentPrefs.uuid,
        ),
      );

      Modular.get<WalletRoutes>().bordereauPage.push(
            BordereauArgs(
              simulation: simulation,
              paymentPreference: paymentPrefs,
            ),
          );
    } catch (e) {
      if (mounted) {
        final message = e is MyHttpClientSideException
            ? (e.message ?? e.toString())
            : e.toString();
        UiAlertHelpers.showErrorToast(message);
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
