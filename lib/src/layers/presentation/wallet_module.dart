import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Widget;
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
    i.addSingleton<bool>(() => isProduction, key: isProductionKey);
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
    i.addSingleton(CheckWithdrawalEligibilityUseCase.new);
    i.addSingleton(ConvertFiatCurrencyUseCase.new);
    i.addSingleton(ExchangeBzcToFiatUseCase.new);
    i.addSingleton(ExchangeFiatToBzcUseCase.new);
    i.addSingleton(GetAllCurrenciesUseCase.new);
    i.addSingleton(GetBzcCurrencyConverterUseCase.new);
    i.addSingleton(GetCurrentUserUseCase.new);
    i.addSingleton(GetExchangeBzcPacksUseCase.new);
    i.addSingleton(GetPaymentPreferencesUseCase.new);
    i.addSingleton(GetTransactionsUseCase.new);
    i.addSingleton(GetUserBalanceUseCase.new);
    i.addSingleton(MakeDepositDirectPaymentUseCase.new);
    i.addSingleton(RequestDepositPaymentLinkUseCase.new);

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
    r.wildcard(child: (_) => const HomePage());
  }
}
