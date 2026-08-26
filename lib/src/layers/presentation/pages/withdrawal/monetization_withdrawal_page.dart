import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/layers/data/models/monetization_account_model.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/diamond_convert_rate_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_kyc_status.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/financial_transaction_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_kyc_status_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_monetization_accounts_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_monetization_eligibility_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_profile_completion_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_transactions_history_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/diamond/convert_diamonds_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/diamond/get_diamond_convert_rate_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart'
    show CurrentUserCubit;
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/user_balance_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/account_type_modal.dart'
    hide AccountType;
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/incomplete_profile_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../../core/network/my_http/my_http.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../../domain/use_cases/payment_preference/get_payment_preferences_use_case.dart';
import 'complete_profile_screen.dart';

// ============================================================================
// PAGE
// ============================================================================
class MonetizationWithdrawalPage extends StatefulWidget {
  const MonetizationWithdrawalPage({super.key});

  @override
  State<MonetizationWithdrawalPage> createState() =>
      _MonetizationWithdrawalPageState();
}

enum _MonetizationState {
  loading,
  error,
  countryRestricted,
  kycRequired,
  taxIdRequired,
  taxIdPending,
  eligible
}

class _MonetizationWithdrawalPageState
    extends State<MonetizationWithdrawalPage> {
  static const int _starsPerDiamond = 200;

  EKycStatus? _kycStatus;
  List<PaymentPreferenceEntity>? _paymentPreferences;
  bool? _isCountryEligible;
  List<MonetizationAccountModel>? _monetizationAccounts;
  bool _isLoadingStatus = true;
  bool _hasError = false;
  DiamondConvertRateEntity? _diamondConvertRate;

  /// True once the user has at least one monetization account with an
  /// approved review status.
  bool get _hasTaxId =>
      _monetizationAccounts?.any((a) => a.isApproved) ?? false;

  List<FinancialTransactionEntity>? _transactions;
  bool _isLoadingTransactions = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([_loadStatus(), _loadTransactions()]);
    await _loadProfileCompletion();
  }

  Future<void> _loadProfileCompletion() async {
    try {
      final result =
          await Modular.get<GetProfileCompletionUseCase>().call(NoParms());
      if (!mounted) return;
      if (!result.isComplete) {
        _showIncompleteProfileModal();
      }
    } catch (_) {
      if (!mounted) return;
    }
  }

  void _showIncompleteProfileModal() {
    if (!mounted) return;
    IncompleteProfileModal.show(
      context,
      onLater: () {
        Navigator.of(context).pop();

        if (Modular.to.canPop()) {
          Modular.to.pop();
        } else {
          Modular.get<WalletRoutes>().home.navigate();
        }
      },
      onComplete: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CompleteProfileScreen(),
          ),
        );
        if (mounted) await _loadProfileCompletion();
      },
    );
  }

  Future<void> _loadStatus() async {
    setState(() {
      _isLoadingStatus = true;
      _hasError = false;
    });
    try {
      final results = await Future.wait([
        Modular.get<GetKycStatusUseCase>().call(NoParms()),
        Modular.get<GetPaymentPreferencesUseCase>().call(NoParms()),
        Modular.get<GetMonetizationEligibilityUseCase>()
            .call(Modular.get<CurrentUserCubit>().state.data?.pays ?? ''),
        Modular.get<GetDiamondConvertRateUseCase>().call(NoParms()),
        Modular.get<GetMonetizationAccountsUseCase>().call(NoParms()),
      ]);
      if (!mounted) return;
      setState(() {
        _kycStatus = results[0] as EKycStatus;
        _paymentPreferences = results[1] as List<PaymentPreferenceEntity>;
        _isCountryEligible = results[2] as bool;
        _diamondConvertRate = results[3] as DiamondConvertRateEntity;
        _monetizationAccounts = results[4] as List<MonetizationAccountModel>;
        _isLoadingStatus = false;
      });
    } catch (e, st) {
      debugPrint('MonetizationWithdrawalPage._loadStatus error: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      setState(() {
        _isLoadingStatus = false;
        _hasError = true;
      });
    }
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoadingTransactions = true);
    try {
      final items = await Modular.get<GetTransactionsUseCase>().call(
        const GetTransactionsParams(
          page: 1,
          limit: 5,
          statuses: [],
          types: [],
          accountType: AccountType.revenue,
        ),
      );
      if (!mounted) return;
      setState(() {
        _transactions = items;
        _isLoadingTransactions = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingTransactions = false);
    }
  }

  _MonetizationState get _state {
    if (_isLoadingStatus) return _MonetizationState.loading;
    if (_hasError) return _MonetizationState.error;
    if (_isCountryEligible == false) {
      return _MonetizationState.countryRestricted;
    }
    if (_kycStatus != EKycStatus.success) return _MonetizationState.kycRequired;
    if (_hasTaxId) return _MonetizationState.eligible;
    // Data submitted but not approved yet -> pending review.
    if (_monetizationAccounts?.isNotEmpty ?? false) {
      return _MonetizationState.taxIdPending;
    }
    return _MonetizationState.taxIdRequired;
  }

  void _goToKycForm() => WalletModule.startKycVerification(context);

  void _onAddPaymentPreference(PaymentPreferenceEntity? pref) {
    if (pref != null) {
      Modular.get<WalletRoutes>()
          .verifiePaiementAccount
          .push(pref)
          .then((e) => _loadAll());
    } else {
      Modular.get<WalletRoutes>()
          .addOrEditPaymentAccount
          .push()
          .then((e) => _loadAll());
    }
  }

  /// Account used to prefill the tax identifier screen: prefer the
  /// 'particulier' one, otherwise the most recent.
  MonetizationAccountModel? get _currentMonetizationAccount {
    final accounts = _monetizationAccounts;
    if (accounts == null || accounts.isEmpty) return null;
    return accounts.firstWhere(
      (a) => a.accountType == 'particulier',
      orElse: () => accounts.first,
    );
  }

  void _onAddTaxId() async {
    final type = await AccountTypeModal.show(context);
    if (type == null || !mounted) return;
    final saved = await Modular.get<WalletRoutes>()
        .taxIdentifier
        .push<bool>(_currentMonetizationAccount);
    if (saved != true || !mounted) return;
    UiAlertHelpers.showSuccessToast(
      LocaleKeys.wallet_module_monetization_page_tax_id_saved.tr(),
    );
    // Refresh the fiscal data state from the API.
    await _loadStatus();
  }

  void _onRequestWithdrawal() =>
      Modular.get<WalletRoutes>().withdrawalRequestForm.push();

  void _openHistory() => Modular.get<WalletRoutes>().transactions.push();

  void _onConvertDiamonds() {
    _showConvertDiamondsDialog();
  }

  void _onConvertStars() {
    UiAlertHelpers.showSuccessToast(
      LocaleKeys.wallet_module_monetization_page_coming_soon.tr(),
    );
  }

  double? get _availableDiamonds {
    final balance = Modular.get<UserBalanceCubit>().state.data;
    return balance?.revenueAccount?.diamonds.balance ?? balance?.diamond;
  }

  Future<void> _showConvertDiamondsDialog() async {
    final available = _availableDiamonds;
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          LocaleKeys.wallet_module_monetization_page_convert_diamonds_title
              .tr(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.wallet_module_monetization_page_stars_rate.tr(
                namedArgs: {'count': '$_starsPerDiamond'},
              ),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            if (available != null)
              Text(
                LocaleKeys.wallet_module_monetization_page_convert_available
                    .tr(namedArgs: {'amount': _formatAmount(available)}),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: LocaleKeys
                    .wallet_module_monetization_page_convert_hint
                    .tr(),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black26, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black26, width: 1),
                ),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              LocaleKeys.wallet_module_common_cancel.tr(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final value =
                  double.tryParse(controller.text.trim().replaceAll(',', '.'));
              if (value == null || value <= 0) {
                UiAlertHelpers.showErrorToast(
                  LocaleKeys
                      .wallet_module_monetization_page_convert_invalid_amount
                      .tr(),
                );
                return;
              }
              Navigator.pop(dialogContext, value);
            },
            child: Text(
              LocaleKeys.wallet_module_common_validate.tr(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
    if (amount == null) return;
    await _convertDiamonds(amount);
  }

  Future<void> _convertDiamonds(double amount) async {
    try {
      await Modular.get<ConvertDiamondsUseCase>().call(
        ConvertDiamondsParams(amount),
      );
      if (!mounted) return;
      await Modular.get<UserBalanceCubit>().fetchUserBalance();
      if (!mounted) return;
      UiAlertHelpers.showSuccessToast(
        LocaleKeys.wallet_module_monetization_page_convert_success.tr(),
      );
    } catch (e) {
      final message = e is MyHttpClientSideException
          ? (e.message ?? e.toString())
          : e.toString();
      if (mounted) {
        UiAlertHelpers.showErrorToast(message);
      }
    }
  }

  void _onOpenMonetizationProgram() {
    Modular.get<WalletRoutes>().monetisationProgramHome.push();
  }

  void _onOpenKycInfo() => _goToKycForm();

  void _copyId(String id) {
    Clipboard.setData(ClipboardData(text: id));
    UiAlertHelpers.showSuccessToast(
      LocaleKeys.wallet_module_common_copied.tr(),
    );
  }

  String _formatAmount(num? value) {
    if (value == null) return '--';
    return NumberFormat('#,##0', 'fr_FR').format(value).replaceAll(',', ' ');
  }

  String _formatDiamondRate() {
    final rate = _diamondConvertRate?.unitPrice;
    if (rate == null) return '--';
    return rate.toStringAsFixed(1).replaceAll('.', ',');
  }

  String _estimatedDigitalAssetsValue(num? diamonds) {
    final rate = _diamondConvertRate?.unitPrice;
    if (diamonds == null || rate == null) return '--';
    return _formatAmount(diamonds * rate);
  }

  String _maskAccountNumber(PaymentPreferenceEntity pref) {
    final raw = pref.detailPhone ?? pref.detailIban ?? '';
    if (raw.length <= 2) return '.xxxxxxx$raw';
    return '.xxxxxxx${raw.substring(raw.length - 2)}';
  }

  @override
  Widget build(BuildContext context) {
    final userBalanceCubit = Modular.get<UserBalanceCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            await userBalanceCubit.fetchUserBalance();
            await _loadAll();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                Text(
                  LocaleKeys.wallet_module_monetization_page_revenue_account
                      .tr(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<UserBalanceCubit, AsyncSnapshot<UserBalanceEntity>>(
                  bloc: userBalanceCubit,
                  builder: (context, balanceSnap) =>
                      _buildBalanceCard(context, balanceSnap.data),
                ),
                const SizedBox(height: 28),
                Text(
                  LocaleKeys.wallet_module_monetization_page_digital_assets
                      .tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<UserBalanceCubit, AsyncSnapshot<UserBalanceEntity>>(
                  bloc: userBalanceCubit,
                  builder: (context, balanceSnap) =>
                      _buildDigitalAssets(context, balanceSnap.data),
                ),
                const SizedBox(height: 24),
                if (_state != _MonetizationState.countryRestricted) ...[
                  Text(
                    LocaleKeys.wallet_module_monetization_page_history.tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _openHistory,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black87,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          LocaleKeys.wallet_module_monetization_page_see_all
                              .tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildHistorySection(),
                  const SizedBox(height: 24),
                ],
                Center(child: _buildCountryBadge(context)),
                const SizedBox(height: 16),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // HEADER
  // --------------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: Modular.to.canPop() ? Modular.to.pop : null,
          child: const Padding(
            padding: EdgeInsets.only(top: 2, right: 8),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 22),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.wallet_module_monetization_page_title.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                LocaleKeys.wallet_module_monetization_page_subtitle.tr(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.4),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------
  // CARTE SOLDE + KYC + CTA + SECTION D'ÉTAT
  // --------------------------------------------------------------------
  Widget _buildBalanceCard(BuildContext context, UserBalanceEntity? balance) {
    final state = _state;
    final isEligible = state == _MonetizationState.eligible;
    final isRestricted = state == _MonetizationState.countryRestricted;
    final kycOk = _kycStatus == EKycStatus.success;

    final accountId = balance?.revenueWalletNumber.isNotEmpty == true
        ? balance!.revenueWalletNumber
        : (balance?.revenueAccount?.walletNumber ?? '...');
    final currencyCode = balance?.revenueAccount?.userCurrencyCode ??
        balance?.userCurrencyCode ??
        'FCFA';
    final amount = balance?.revenueAccount?.userCurrencyBalance ??
        balance?.revenueUserCurrencyBalance;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.wallet_module_monetization_page_estimated_balance
                      .tr(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45,
                    letterSpacing: 0.6,
                  ),
                ),
                const Spacer(),
                _buildKycBadge(kycOk),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isRestricted ? '--' : _formatAmount(amount),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              currencyCode,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.black38),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    LocaleKeys.wallet_module_common_account_id.tr(
                      namedArgs: {'id': accountId},
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () => _copyId(accountId),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.copy, size: 16, color: Colors.black38),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEligible ? _onRequestWithdrawal : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: const Color(0xFFBAB9B9),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  LocaleKeys.wallet_module_monetization_page_collect_earnings
                      .tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (!kycOk) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _onAddPaymentPreference(null),
                  icon: const Icon(Icons.credit_card, size: 18),
                  label: Text(
                    LocaleKeys
                        .wallet_module_monetization_page_add_settlement_account
                        .tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.black26),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ..._buildStateSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildKycBadge(bool kycOk) {
    final color = kycOk ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C);
    final label = kycOk
        ? LocaleKeys.wallet_module_monetization_page_kyc_verified.tr()
        : LocaleKeys.wallet_module_monetization_page_kyc_to_verify.tr();
    final icon = kycOk ? Icons.check_circle : Icons.remove_circle;

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section variable sous les boutons, selon l'état :
  /// - éligible + KYC ok        -> "Compte de Règlement"
  /// - éligible + KYC pas ok    -> "KYC REQUIS" + "Programme de Monétisation"
  /// - identifiant fiscal manquant -> "Identifiant Fiscal REQUIS" + "Programme de Monétisation"
  /// - identifiant fiscal en attente -> "Identifiant Fiscal EN COURS DE VALIDATION" + "Programme de Monétisation"
  /// - pays non éligible        -> "Monétisation restreinte" uniquement
  List<Widget> _buildStateSection() {
    switch (_state) {
      case _MonetizationState.countryRestricted:
        return [
          _buildInfoRow(
            title: LocaleKeys
                .wallet_module_monetization_page_monetization_restricted
                .tr(),
            description: LocaleKeys
                .wallet_module_monetization_page_monetization_restricted_description
                .tr(),
            onTap: _onOpenMonetizationProgram,
          ),
        ];
      case _MonetizationState.kycRequired:
        return [
          _buildInfoRow(
            title: LocaleKeys.wallet_module_monetization_page_kyc_required.tr(),
            description: LocaleKeys
                .wallet_module_monetization_page_kyc_required_description
                .tr(),
            onTap: _onOpenKycInfo,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            title:
                LocaleKeys.wallet_module_monetization_page_program_title.tr(),
            description: LocaleKeys
                .wallet_module_monetization_page_program_description
                .tr(),
            onTap: _onOpenMonetizationProgram,
          ),
        ];
      case _MonetizationState.taxIdPending:
      case _MonetizationState.taxIdRequired:
        return [
          _buildInfoRow(
            title: (_state == _MonetizationState.taxIdPending
                    ? LocaleKeys.wallet_module_monetization_page_tax_id_pending
                    : LocaleKeys
                        .wallet_module_monetization_page_tax_id_required)
                .tr(),
            description: (_state == _MonetizationState.taxIdPending
                    ? LocaleKeys
                        .wallet_module_monetization_page_tax_id_pending_description
                    : LocaleKeys
                        .wallet_module_monetization_page_tax_id_required_description)
                .tr(),
            onTap: _onAddTaxId,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            title:
                LocaleKeys.wallet_module_monetization_page_program_title.tr(),
            description: LocaleKeys
                .wallet_module_monetization_page_program_description
                .tr(),
            onTap: _onOpenMonetizationProgram,
          ),
        ];
      case _MonetizationState.eligible:
        final prefOrdList = _paymentPreferences!
          ..sort((a, b) {
            if (a.updatedAt == null && b.updatedAt == null) {
              return b.createdAt!.compareTo(a.createdAt!);
            }
            if (a.updatedAt == null) return 1;
            if (b.updatedAt == null) return -1;
            return b.updatedAt!.compareTo(a.updatedAt!);
          });
        final pref = (prefOrdList.isNotEmpty) ? prefOrdList.first : null;
        final masked = pref != null ? _maskAccountNumber(pref) : '...';
        return [
          _buildInfoRow(
            title: LocaleKeys.wallet_module_monetization_page_settlement_account
                .tr(),
            description: LocaleKeys
                .wallet_module_monetization_page_settlement_account_description
                .tr(namedArgs: {'account': masked}),
            onTap: () => _onAddPaymentPreference(pref),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            title:
                LocaleKeys.wallet_module_monetization_page_program_title.tr(),
            description: LocaleKeys
                .wallet_module_monetization_page_program_description
                .tr(),
            onTap: _onOpenMonetizationProgram,
          ),
        ];
      case _MonetizationState.loading:
      case _MonetizationState.error:
        return [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ];
    }
  }

  Widget _buildInfoRow({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 6),
            child: Icon(Icons.chevron_right, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // ACTIFS DIGITAUX (DIAMANTS / ÉTOILES) + VALEUR ESTIMÉE
  // --------------------------------------------------------------------
  Widget _buildDigitalAssets(BuildContext context, UserBalanceEntity? balance) {
    final restricted = _state == _MonetizationState.countryRestricted;
    final diamonds =
        balance?.revenueAccount?.diamonds.balance ?? balance?.diamond;
    final stars = balance?.revenueAccount?.stars.balance ?? balance?.stars;

    return Column(
      children: [
        _buildAssetCard(
          iconBg: const Color(0xFFF6E4FB),
          icon: Icons.diamond,
          iconColor: const Color(0xFFCB4FE0),
          label: LocaleKeys.wallet_module_monetization_page_diamonds.tr(),
          value: restricted ? '-' : _formatAmount(diamonds),
          rateLabel: LocaleKeys.wallet_module_monetization_page_diamond_rate.tr(
            namedArgs: {
              'rate': _formatDiamondRate(),
              'currency': _diamondConvertRate?.currencySymbol ?? 'FCFA',
            },
          ),
          onConvert: restricted ? null : _onConvertDiamonds,
        ),
        const SizedBox(height: 12),
        _buildAssetCard(
          iconBg: const Color(0xFFFCF2DC),
          icon: Icons.star,
          iconColor: const Color(0xFFF3A712),
          label: LocaleKeys.wallet_module_monetization_page_stars.tr(),
          value: restricted ? '-' : _formatAmount(stars),
          rateLabel: LocaleKeys.wallet_module_monetization_page_stars_rate.tr(
            namedArgs: {'count': '$_starsPerDiamond'},
          ),
          onConvert: restricted ? null : _onConvertStars,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 18,
                color: Colors.black45,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  LocaleKeys.wallet_module_monetization_page_estimated_value
                      .tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                _estimatedDigitalAssetsValue(diamonds),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _diamondConvertRate?.currencySymbol ?? 'FCFA',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetCard({
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String rateLabel,
    required VoidCallback? onConvert,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rateLabel,
                style: const TextStyle(fontSize: 10.5, color: Colors.black38),
              ),
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: onConvert,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  disabledForegroundColor: Colors.black26,
                  side: BorderSide(
                    color: onConvert != null ? Colors.black26 : Colors.black12,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  LocaleKeys.wallet_module_monetization_page_convert.tr(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------
  // HISTORIQUE
  // --------------------------------------------------------------------
  Widget _buildHistorySection() {
    if (_isLoadingTransactions) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (_transactions == null || _transactions!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            LocaleKeys.wallet_module_common_no_transaction.tr(),
            style: const TextStyle(color: Colors.black45),
          ),
        ),
      );
    }
    return Column(children: _transactions!.map(_buildHistoryTile).toList());
  }

  bool _isCredit(FinancialTransactionEntity tx) {
    return switch (tx.type) {
      EFinancialTxType.deposit ||
      EFinancialTxType.credit ||
      EFinancialTxType.internalIn =>
        true,
      EFinancialTxType.debit ||
      EFinancialTxType.withdrawal ||
      EFinancialTxType.internalOut =>
        false,
    };
  }

  String _titleFor(FinancialTransactionEntity tx) {
    if (tx.description != null && tx.description!.isNotEmpty) {
      return tx.description!;
    }
    return switch (tx.type) {
      EFinancialTxType.deposit =>
        LocaleKeys.wallet_module_common_tx_deposit.tr(),
      EFinancialTxType.debit => LocaleKeys.wallet_module_common_tx_debit.tr(),
      EFinancialTxType.credit => LocaleKeys.wallet_module_common_tx_credit.tr(),
      EFinancialTxType.withdrawal =>
        LocaleKeys.wallet_module_common_tx_withdrawal.tr(),
      EFinancialTxType.internalIn =>
        LocaleKeys.wallet_module_common_tx_internal_in.tr(),
      EFinancialTxType.internalOut =>
        LocaleKeys.wallet_module_common_tx_internal_out.tr(),
    };
  }

  Widget _buildHistoryTile(FinancialTransactionEntity tx) {
    final isCredit = _isCredit(tx);
    final amountColor = isCredit ? const Color(0xFF2ECC71) : Colors.black;
    final sign = isCredit ? '+' : '−';
    final amountText =
        '$sign${tx.amount.abs().toStringAsFixed(0).replaceAll('.', ',')}';
    final isCredited = isCredit && tx.status == EFinancialTxStatus.success;
    final statusLabel = isCredited
        ? LocaleKeys.wallet_module_common_credited.tr()
        : LocaleKeys.wallet_module_common_successful.tr();
    final statusColor =
        isCredited ? const Color(0xFFDFF7E4) : const Color(0xFFF0F0F0);
    final statusTextColor =
        isCredited ? const Color(0xFF2ECC71) : Colors.black45;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleFor(tx),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(tx.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$amountText ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: amountColor,
                      ),
                    ),
                    TextSpan(
                      text: tx.inputCurrency,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(
      'dd MMM yyyy • HH:mm',
      BantuWalletLocalization.currentLanguageCode,
    ).format(date);
  }

  // --------------------------------------------------------------------
  // BADGE PAYS + FOOTER
  // --------------------------------------------------------------------
  Widget _buildCountryBadge(BuildContext context) {
    return BlocSelector<CurrentUserCubit, AsyncSnapshot<UserEntity>,
        UserEntity?>(
      bloc: Modular.get<CurrentUserCubit>(),
      selector: (state) => state.data,
      builder: (context, currencyCode) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public, size: 14, color: Colors.black45),
            const SizedBox(width: 6),
            Text(
              LocaleKeys.wallet_module_monetization_page_country_with_currency
                  .tr(
                namedArgs: {
                  'country': currencyCode?.pays != null
                      ? CountryCode.fromCountryCode(currencyCode?.pays ?? '')
                              .name ??
                          '--'
                      : '--',
                  'currency': currencyCode?.monetaryZone?.currencyIso ?? '--',
                },
              ),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 13,
              color: Colors.black38,
            ),
            const SizedBox(width: 6),
            Text(
              LocaleKeys.wallet_module_monetization_page_secure_transactions
                  .tr(),
              style: const TextStyle(fontSize: 11.5, color: Colors.black45),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          LocaleKeys.wallet_module_monetization_page_delay_info.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10.5, color: Colors.black38),
        ),
      ],
    );
  }
}
