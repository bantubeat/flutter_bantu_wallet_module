import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/network/api_constants.dart';
import 'core/network/my_http/my_http.dart';
import 'layers/data/data_sources/bantubeat_api_data_source.dart';
import 'layers/data/repositories/balance_repository_impl.dart';
import 'layers/data/repositories/public_repository_impl.dart';
import 'layers/domain/repositories/balance_repository.dart';
import 'layers/domain/repositories/public_repository.dart';
import 'layers/domain/use_cases/get_all_currencies_use_case.dart';
import 'layers/domain/use_cases/get_user_balance_use_case.dart';
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
    // -- Domain Use Cases
    i.addSingleton(GetUserBalanceUseCase.new);
    i.addSingleton(GetAllCurrenciesUseCase.new);

    // Presentation layer dependencies
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
