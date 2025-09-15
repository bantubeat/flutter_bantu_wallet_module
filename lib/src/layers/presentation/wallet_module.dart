import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Widget;
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/check_payment_preferences_verification_code_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/update_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/withdrawal_request_form/withdrawal_request_form_page.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/withdrawal_request_resume/withdrawal_request_resume_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/config/wallet_api_keys.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/my_http/my_http.dart';

import '../../layers/data/data_sources/bantubeat_api_data_source.dart';
import '../../layers/data/repositories/exchange_repository_impl.dart';
import '../../layers/data/repositories/payment_repository_impl.dart';
import '../../layers/data/repositories/user_repository_impl.dart';
import '../../layers/data/repositories/balance_repository_impl.dart';
import '../../layers/data/repositories/public_repository_impl.dart';

import '../../layers/domain/repositories/exchange_repository.dart';
import '../../layers/domain/repositories/balance_repository.dart';
import '../../layers/domain/repositories/payment_repository.dart';
import '../../layers/domain/repositories/public_repository.dart';
import '../../layers/domain/repositories/user_repository.dart';
import '../../layers/domain/use_cases/check_withdrawal_eligibility_use_case.dart';
import '../../layers/domain/use_cases/convert_fiat_currency_use_case.dart';
import '../../layers/domain/use_cases/exchange_bzc_to_fiat_use_case.dart';
import '../../layers/domain/use_cases/get_bzc_currency_converter_use_case.dart';
import '../../layers/domain/use_cases/get_current_user_use_case.dart';
import '../../layers/domain/use_cases/get_exchange_bzc_packs_use_case.dart';
import '../../layers/domain/use_cases/get_payment_preferences_use_case.dart';
import '../../layers/domain/use_cases/get_transactions_history_use_case.dart';
import '../../layers/domain/use_cases/exchange_fiat_to_bzc_use_case.dart';
import '../../layers/domain/use_cases/get_all_currencies_use_case.dart';
import '../../layers/domain/use_cases/get_user_balance_use_case.dart';
import '../../layers/domain/use_cases/make_deposit_direct_payment_use_case.dart';
import '../../layers/domain/use_cases/request_deposit_payment_link_use_case.dart';

import '../../layers/presentation/cubits/current_user_cubit.dart';
import '../../layers/presentation/cubits/user_balance_cubit.dart';
import '../../layers/presentation/pages/buy_beatzcoins/buy_beatzcoins_page.dart';
import '../../layers/presentation/pages/deposit/deposit_page.dart';
import '../../layers/presentation/pages/home/home_page.dart';
import '../../layers/presentation/pages/transactions/transactions_page.dart';
import '../../layers/presentation/pages/balance/balance_page.dart';
import '../../layers/presentation/pages/withdrawal/withdrawal_page.dart';
import '../../layers/presentation/pages/beatzcoins/beatzcoins_page.dart';
import '../../layers/presentation/navigation/wallet_routes.dart';
import '../domain/use_cases/generate_withdrawal_payment_slip_use_case.dart';
import 'pages/add_payment_account/add_payment_account_page.dart';

class WalletModule extends Module {
  static const floatingMenuBuilderKey = 'floatingMenuBuilder';
  static const isProductionKey = 'isProduction';

  final Widget Function() floatingMenuBuilder;
  final Future<String?> Function() getAccessToken;
  final WalletRoutes _routes;
  final bool isProduction;
  final WalletApiKeys walletApiKeys;

  WalletModule({
    required this.floatingMenuBuilder,
    required this.getAccessToken,
    required this.walletApiKeys,
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
    return Modular.get<Widget>(key: floatingMenuBuilderKey);
  }

  @override
  void binds(i) {
    const withCacheKey = 'with_cache_key';
    i.add<bool>(() => isProduction, key: isProductionKey);
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
    i.add(GetTransactionsUseCase.new);
    i.add(GetUserBalanceUseCase.new);
    i.add(MakeDepositDirectPaymentUseCase.new);
    i.add(RequestDepositPaymentLinkUseCase.new);
    i.add(GetPaymentPreferencesUseCase.new);
    i.add(UpdatePaymentPreferencesUseCase.new);
    i.add(CheckPaymentPreferencesverificationCodeUseCase.new);
    i.add(GenerateWithdrawalPaymentSlipUseCase.new);

    // Presentation layer dependencies
    i.addSingleton(CurrentUserCubit.new);
    i.addSingleton(UserBalanceCubit.new);
    i.addSingleton(floatingMenuBuilder, key: floatingMenuBuilderKey);
    i.addInstance<WalletRoutes>(_routes);
  }

  @override
  void routes(r) {
    r.child(_routes.home.wp, child: (_) => const HomePage());
    r.child(_routes.balance.wp, child: (_) => const BalancePage());
    r.child(_routes.deposit.wp, child: (_) => const DepositPage());
    r.child(_routes.withdrawal.wp, child: (_) => const WithdrawalPage());
    r.child(_routes.beatzcoins.wp, child: (_) => const BeatzcoinsPage());
    r.child(_routes.buyBeatzcoins.wp, child: (_) => const BuyBeatzcoinsPage());
    r.child(_routes.transactions.wp, child: (_) => const TransactionsPage());

    r.child(
      _routes.addPaymentAccount.wp,
      child: (_) => const AddPaymentAccountPage(),
    );

    r.child(
      _routes.withdrawalRequestForm.wp,
      child: (_) => const WithdrawalRequestFormPage(),
    );

    r.child(
      _routes.withdrawalRequestResume.wp,
      child: (_) => WithdrawalRequestResumePage(r.args.data),
    );

    r.wildcard(child: (_) => const HomePage());
  }
}
