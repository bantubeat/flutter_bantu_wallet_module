import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_kyc_status_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/delete_kyc_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/save_monetization_account_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/save_personal_infos_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_profile_completion_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/start_kyc_session_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/upload_monetization_document_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/update_user_profile_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/check_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/check_payment_preferences_email_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/resend_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/resend_payment_preferences_email_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/update_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/request_withdrawal_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/balance/paiement_account_page.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/register_paiement_account/payment_account_form_screen.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/update_paiement_account/account_verification_screen.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/withdrawal/monetization_withdrawal_page.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/withdrawal/tax_identifier_screen.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/withdrawal_request_form/withdrawal_request_form_page.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/withdrawal_request_resume/withdrawal_request_resume_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:didit_sdk/sdk_flutter.dart';

import '../../core/config/wallet_api_keys.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/my_http/my_http.dart';

import '../../layers/data/data_sources/bantubeat_api_data_source.dart';
import '../../layers/data/models/kyc_session_model.dart';
import '../../layers/data/models/monetization_account_model.dart';
import '../../layers/data/repositories/exchange_repository_impl.dart';
import '../../layers/data/repositories/payment_repository_impl.dart';
import '../../layers/data/repositories/user_repository_impl.dart';
import '../../layers/data/repositories/balance_repository_impl.dart';
import '../../layers/data/repositories/public_repository_impl.dart';

import '../../layers/domain/entities/kyc_session_entity.dart';
import '../../layers/domain/repositories/exchange_repository.dart';
import '../../layers/domain/repositories/balance_repository.dart';
import '../../layers/domain/repositories/payment_repository.dart';
import '../../layers/domain/repositories/public_repository.dart';
import '../../layers/domain/repositories/user_repository.dart';
import '../domain/entities/payment_preference_entity.dart';
import '../domain/use_cases/account/get_monetization_eligibility_use_case.dart';
import '../domain/use_cases/withdrawal/check_withdrawal_eligibility_use_case.dart';
import '../domain/use_cases/currency/convert_fiat_currency_use_case.dart';
import '../domain/use_cases/bzc_exchange/exchange_bzc_to_fiat_use_case.dart';
import '../domain/use_cases/bzc_exchange/get_bzc_currency_converter_use_case.dart';
import '../domain/use_cases/bzc_exchange/get_token_prices_use_case.dart';
import '../domain/use_cases/diamond/convert_diamonds_use_case.dart';
import '../domain/use_cases/diamond/get_diamond_convert_rate_use_case.dart';
import '../domain/use_cases/account/get_current_user_use_case.dart';
import '../domain/use_cases/account/get_monetization_accounts_use_case.dart';
import '../domain/use_cases/bzc_exchange/get_exchange_bzc_packs_use_case.dart';
import '../domain/use_cases/bzc_exchange/purchase_token_pack_use_case.dart';
import '../domain/use_cases/payment_preference/get_payment_preferences_use_case.dart';
import '../domain/use_cases/account/get_transactions_history_use_case.dart';
import '../domain/use_cases/bzc_exchange/exchange_fiat_to_bzc_use_case.dart';
import '../domain/use_cases/currency/get_all_currencies_use_case.dart';
import '../domain/use_cases/account/get_user_balance_use_case.dart';
import '../domain/use_cases/balance/get_payout_methods_use_case.dart';
import '../domain/use_cases/deposit/make_deposit_direct_payment_use_case.dart';
import '../domain/use_cases/deposit/request_deposit_payment_link_use_case.dart';

import '../../layers/presentation/cubits/current_user_cubit.dart';
import '../../layers/presentation/cubits/user_balance_cubit.dart';
import '../../layers/presentation/helpers/ui_alert_helpers.dart';
import '../../layers/presentation/widgets/account_type_modal.dart';
import '../../layers/presentation/pages/buy_beatzcoins/buy_beatzcoins_page.dart';
import '../../layers/presentation/pages/deposit/deposit_page.dart';
import '../../layers/presentation/pages/home/home_page.dart';
import '../../layers/presentation/pages/transactions/transactions_page.dart';
import '../../layers/presentation/pages/beatzcoins/beatzcoins_page.dart';
import '../../layers/presentation/navigation/wallet_routes.dart';
import '../domain/use_cases/withdrawal/generate_withdrawal_payment_slip_use_case.dart';
import '../domain/use_cases/withdrawal/send_withdrawal_mail_otp_use_case.dart';
import 'pages/home/featlink_wallet_page.dart';
import 'pages/menetisation_program/monetization_home_page.dart';

class WalletModule extends Module {
  static const _floatingMenuBuilderKey = 'WalletModule@floatingMenuBuilder';
  static const _onGoToKycFormKey = 'WalletModule@onGoToKycForm';
  static const _isProductionKey = 'WalletModule@isProduction';
  static const _onCloseModule = 'WalletModule@onCloseModule';

  final Widget Function() floatingMenuBuilder;
  final VoidCallback onCloseModule;
  final Future<String?> Function() getAccessToken;
  final VoidCallback? onGoToKycForm;
  final WalletRoutes _routes;
  final bool isProduction;
  final WalletApiKeys walletApiKeys;

  WalletModule({
    required this.onCloseModule,
    required this.floatingMenuBuilder,
    required this.getAccessToken,
    required this.walletApiKeys,
    required this.onGoToKycForm,
    required WalletRoutes routes,
    this.isProduction = kReleaseMode,
  }) : _routes = routes;

  MyHttpClient Function() _initMyHttpClient({required bool withCache}) {
    return () {
      return MyHttpClientDioImplemenation(
        baseUrl: ApiConstants.baseUrl,
        cacheEnabled: withCache,
        getAccessToken: getAccessToken,
      );
    };
  }

  static Widget getFloatingMenuWidget() {
    return Modular.get<Widget>(key: _floatingMenuBuilderKey);
  }

  static void goToKycForm() {
    final cb = Modular.tryGet<VoidCallback>(key: _onGoToKycFormKey);
    if (cb != null) cb();
  }

  /// Starts the Didit KYC verification flow: shows the account type selector,
  /// then creates a new session via the API and launches the Didit native SDK.
  /// While the API and the Didit SDK are called a loading overlay is shown.
  /// If a KYC session already exists but is still pending with a didit session,
  /// the existing session is resumed, otherwise the API error message is
  /// displayed to the user.
  static Future<void> startKycVerification(BuildContext context) async {
    final type = await AccountTypeModal.show(context);
    if (type == null || !context.mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    var loaderOpen = false;
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      ).then((_) => loaderOpen = false),
    );
    loaderOpen = true;

    try {
      final session = await Modular.get<StartKycSessionUseCase>().call(
        StartKycSessionParams(isCompany: type.isCompany),
      );
      await _openDiditSession(session);
    } on MyHttpClientSideException catch (e) {
      await _openDiditSessionFromError(e);
    } catch (err) {
      debugPrint('[WalletModule.startKycVerification] error: $err');
    } finally {
      if (loaderOpen && navigator.canPop()) navigator.pop();
    }
  }

  static Future<void> _openDiditSessionFromError(
    MyHttpClientSideException e,
  ) async {
    final kyc = e.body?['kyc'];
    if (kyc is Map) {
      final existing = KycSessionModel.fromJson(e.body!);
      if (await _openDiditSession(existing)) return;
    }
    final message = e.message;
    if (message != null && message.isNotEmpty) {
      UiAlertHelpers.showErrorToast(message);
    }
  }

  /// Opens the Didit native verification UI when the KYC status is PENDING
  /// and a didit session token/id is available. Returns false otherwise.
  static Future<bool> _openDiditSession(KycSessionEntity session) async {
    final isPending = session.status?.toUpperCase() == 'PENDING';
    final token = session.sessionToken;
    if (!isPending || token == null || token.isEmpty) return false;

    final res = await DiditSdk.startVerification(
      token,
      config: const DiditConfig(loggingEnabled: kDebugMode),
    );

    switch (res) {
      case VerificationCompleted(:final session):
        debugPrint('Status: ${session.status}');
        debugPrint('Session ID: ${session.sessionId}');
        UiAlertHelpers.showSuccessToast(
          '✅ Vérification KYC terminée avec succès !',
        );
      case VerificationCancelled():
        UiAlertHelpers.showErrorToast('❌ La vérification KYC a été annulée');
        debugPrint('User cancelled');
        unawaited(
          Modular.get<DeleteKycUseCase>().call(NoParms()).catchError((err) {
            debugPrint('[WalletModule] delete KYC on cancel: $err');
          }),
        );
      case VerificationFailed(:final error):
        String errorMessage = _getErrorMessage(error);
        UiAlertHelpers.showErrorToast(errorMessage);
        debugPrint('Error: ${error.type} - ${error.message}');
    }

    return true;
  }

  static String _getErrorMessage(VerificationError error) {
    switch (error.type) {
      case VerificationErrorType.sessionExpired:
        return 'La session a expiré. Veuillez recommencer le processus';
      case VerificationErrorType.networkError:
        return 'Erreur réseau. Vérifiez votre connexion internet';
      case VerificationErrorType.cameraAccessDenied:
        return "Accès à la caméra refusé. Autorisez l'accès dans les paramètres";
      case VerificationErrorType.notInitialized:
        return "Le SDK n'est pas initialisé. Veuillez réessayer";
      case VerificationErrorType.apiError:
        return 'Erreur serveur. Veuillez réessayer plus tard';
      case VerificationErrorType.retryBlocked:
        return 'Trop de tentatives. Veuillez réessayer plus tard';
      case VerificationErrorType.unknown:
        return 'Erreur inconnue : ${error.message}';
    }
  }

  static void handleCloseModule() {
    final cb = Modular.tryGet<void Function()>(key: _onCloseModule);
    if (cb != null) cb();
  }

  static bool getIsProduction() {
    return Modular.tryGet<bool>(key: _isProductionKey) ?? kReleaseMode;
  }

  @override
  void binds(i) {
    const withCacheKey = 'WalletModule@with_cache_key';
    i.add<bool>(() => isProduction, key: _isProductionKey);
    // Core
    i.addSingleton<MyHttpClient>(_initMyHttpClient(withCache: false));
    i.addSingleton<MyHttpClient>(
      _initMyHttpClient(withCache: true),
      key: withCacheKey,
    );
    i.addInstance<WalletApiKeys>(walletApiKeys);

    // Data layer dependencies
    i.addSingleton(
      () => BantubeatApiDataSource(
        client: Modular.get<MyHttpClient>(),
        cachedClient: Modular.get<MyHttpClient>(key: withCacheKey),
      ),
    );

    // Domain layer dependencies
    // -- Domain Reposities
    i.addSingleton<BalanceRepository>(BalanceRepositoryImpl.new);
    i.addSingleton<PublicRepository>(PublicRepositoryImpl.new);
    i.addSingleton<ExchangeRepository>(ExchangeRepositoryImpl.new);
    i.addSingleton<UserRepository>(UserRepositoryImpl.new);
    i.addSingleton<PaymentRepository>(PaymentRepositoryImpl.new);

    // -- Domain Use Cases
    i.add(CheckWithdrawalEligibilityUseCase.new);
    i.add(ConvertFiatCurrencyUseCase.new);
    i.add(ExchangeBzcToFiatUseCase.new);
    i.add(ExchangeFiatToBzcUseCase.new);
    i.add(GetAllCurrenciesUseCase.new);
    i.add(GetBzcCurrencyConverterUseCase.new);
    i.add(GetCurrentUserUseCase.new);
    i.add(GetExchangeBzcPacksUseCase.new);
    i.add(GetTokenPricesUseCase.new);
    i.add(GetDiamondConvertRateUseCase.new);
    i.add(ConvertDiamondsUseCase.new);
    i.add(GetTransactionsUseCase.new);
    i.add(GetUserBalanceUseCase.new);
    i.add(GetMonetizationEligibilityUseCase.new);
    i.add(GetMonetizationAccountsUseCase.new);
    i.add(MakeDepositDirectPaymentUseCase.new);
    i.add(PurchaseTokenPackUseCase.new);
    i.add(RequestDepositPaymentLinkUseCase.new);
    i.add(GetPaymentPreferencesUseCase.new);
    i.add(UpdatePaymentPreferencesUseCase.new);
    i.add(CheckPaymentPreferencesVerificationCodeUseCase.new);
    i.add(CheckPaymentPreferencesEmailVerificationCodeUseCase.new);
    i.add(GenerateWithdrawalPaymentSlipUseCase.new);
    i.add(SendWithdrawalMailOtpUseCase.new);
    i.add(RequestWithdrawalUseCase.new);
    i.add(GetKycStatusUseCase.new);
    i.add(StartKycSessionUseCase.new);
    i.add(DeleteKycUseCase.new);
    i.add(UploadMonetizationDocumentUseCase.new);
    i.add(SaveMonetizationAccountUseCase.new);
    i.add(UpdateUserProfileUseCase.new);
    i.add(SavePersonalInfosUseCase.new);
    i.add(GetProfileCompletionUseCase.new);
    i.add(GetPayoutMethodsUseCase.new);
    i.add(ResendPaymentPreferencesVerificationCodeUseCase.new);
    i.add(ResendPaymentPreferencesEmailVerificationCodeUseCase.new);

    // Presentation layer dependencies
    i.addSingleton(CurrentUserCubit.new);
    i.addSingleton(UserBalanceCubit.new);
    i.addSingleton(floatingMenuBuilder, key: _floatingMenuBuilderKey);
    i.addSingleton(() => onGoToKycForm, key: _onGoToKycFormKey);
    i.addSingleton(() => onCloseModule, key: _onCloseModule);

    i.addInstance<WalletRoutes>(_routes);
  }

  @override
  void routes(r) {
    r.child(_routes.home.wp, child: (_) => const FeatlinkWalletPage());
    r.child(
      _routes.monetisationProgramHome.wp,
      child: (_) => const MonetizationHomePage(),
    );
    r.child(_routes.balance.wp, child: (_) => const PaiementAccountPage());

    r.child(_routes.deposit.wp, child: (_) => const DepositPage());
    r.child(
      _routes.withdrawal.wp,
      child: (_) => const MonetizationWithdrawalPage(),
    );
    // r.child(_routes.withdrawal.wp, child: (_) => const WithdrawalPage());
    r.child(_routes.beatzcoins.wp, child: (_) => const BeatzcoinsPage());
    r.child(_routes.buyBeatzcoins.wp, child: (_) => const BuyBeatzcoinsPage());
    r.child(_routes.transactions.wp, child: (_) => const TransactionsPage());
    r.child(
      _routes.verifiePaiementAccount.wp,
      child: (_) =>
          AccountVerificationScreen(r.args.data as PaymentPreferenceEntity),
    );
    r.child(
      _routes.addOrEditPaymentAccount.wp,
      child: (_) => const PaymentAccountFormScreen(),
    );
    // r.child(
    //   _routes.addOrEditPaymentAccount.wp,
    //   child: (_) {
    //     final arg = r.args.data;
    //     if (arg == null ||
    //         arg is PaymentPreferenceEntity ||
    //         arg is PaymentPreferenceEntity?) {
    //       return AddOrEditPaymentAccountPage(arg as PaymentPreferenceEntity?);
    //     }
    //     return const AddOrEditPaymentAccountPage(null);
    //   },
    // );

    r.child(
      _routes.withdrawalRequestForm.wp,
      child: (_) => const WithdrawalRequestFormPage(),
    );

    r.child(
      _routes.taxIdentifier.wp,
      child: (_) => TaxIdentifierScreen(
        account: r.args.data as MonetizationAccountModel?,
      ),
    );

    r.child(
      _routes.withdrawalRequestResume.wp,
      child: (_) => WithdrawalRequestResumePage(r.args.data),
    );

    r.wildcard(child: (_) => const HomePage());
    // r.child(_routes.home.wp, child: (_) => const HomePage());
    // r.child(_routes.balance.wp, child: (_) => const BalancePage());
  }
}
