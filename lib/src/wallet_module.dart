import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/network/api_constants.dart';
import 'core/network/my_http/my_http.dart';

import 'layers/data/data_sources/bantubeat_api_data_source.dart';
import 'layers/data/repositories/exchange_repository_impl.dart';
import 'layers/data/repositories/user_repository_impl.dart';
import 'layers/data/repositories/balance_repository_impl.dart';
import 'layers/data/repositories/public_repository_impl.dart';

import 'layers/domain/repositories/exchange_repository.dart';
import 'layers/domain/repositories/balance_repository.dart';
import 'layers/domain/repositories/public_repository.dart';
import 'layers/domain/repositories/user_repository.dart';
import 'layers/domain/use_cases/check_withdrawal_eligibility_use_case.dart';
import 'layers/domain/use_cases/convert_fiat_currency_use_case.dart';
import 'layers/domain/use_cases/exchange_bzc_to_fiat_use_case.dart';
import 'layers/domain/use_cases/get_current_user_use_case.dart';
import 'layers/domain/use_cases/get_exchange_bzc_packs_use_case.dart';
import 'layers/domain/use_cases/get_payment_preferences_use_case.dart';
import 'layers/domain/use_cases/get_transactions_history_use_case.dart';
import 'layers/domain/use_cases/exchange_fiat_to_bzc_use_case.dart';
import 'layers/domain/use_cases/get_all_currencies_use_case.dart';
import 'layers/domain/use_cases/get_user_balance_use_case.dart';

import 'layers/presentation/cubit/current_user_cubit.dart';
import 'layers/presentation/cubit/user_balance_cubit.dart';
import 'layers/presentation/pages/buy_beatzcoins/buy_beatzcoins_page.dart';
import 'layers/presentation/pages/deposit/deposit_page.dart';
import 'layers/presentation/pages/home/home_page.dart';
import 'layers/presentation/pages/transactions_history/transactions_history_page.dart';
import 'layers/presentation/pages/wallets/wallets_page.dart';
import 'layers/presentation/pages/withdrawal/withdrawal_page.dart';
import 'layers/presentation/pages/beatzcoins/beatzcoins_page.dart';

class WalletModule extends Module {
  static const floatingMenuBuilderKey = 'floatingMenuBuilder';

  final Widget Function() floatingMenuBuilder;
  final Future<String?> Function() getAccessToken;

  WalletModule({
    required this.floatingMenuBuilder,
    required this.getAccessToken,
  });

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
    // Core
    i.addSingleton<MyHttpClient>(_initMyHttpClient(withCache: false));
    i.addSingleton<MyHttpClient>(
      _initMyHttpClient(withCache: true),
      key: withCacheKey,
    );

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

    // -- Domain Use Cases
    i.addSingleton(CheckWithdrawalEligibilityUseCase.new);
    i.addSingleton(ConvertFiatCurrencyUseCase.new);
    i.addSingleton(ExchangeBzcToFiatUseCase.new);
    i.addSingleton(ExchangeFiatToBzcUseCase.new);
    i.addSingleton(GetAllCurrenciesUseCase.new);
    i.addSingleton(GetCurrentUserUseCase.new);
    i.addSingleton(GetExchangeBzcPacksUseCase.new);
    i.addSingleton(GetPaymentPreferencesUseCase.new);
    i.addSingleton(GetTransactionsHistoryUseCase.new);
    i.addSingleton(GetUserBalanceUseCase.new);

    // Presentation layer dependencies
    i.addSingleton(CurrentUserCubit.new);
    i.addSingleton(UserBalanceCubit.new);
    i.addSingleton(floatingMenuBuilder, key: floatingMenuBuilderKey);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => HomePage());
    r.child(WalletsPage.pageRoute, child: (_) => WalletsPage());
    r.child(DepositPage.pageRoute, child: (_) => DepositPage());
    r.child(WithdrawalPage.pageRoute, child: (_) => WithdrawalPage());
    r.child(BeatzcoinsPage.pageRoute, child: (_) => BeatzcoinsPage());
    r.child(BuyBeatzcoinsPage.pageRoute, child: (_) => BuyBeatzcoinsPage());
    r.child(
      TransactionsHistoryPage.pageRoute,
      child: (_) => TransactionsHistoryPage(),
    );
  }
}
