import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/my_http/my_http.dart';
import 'data/data_sources/balance_remote_data_source.dart';
import 'data/repositories/balance_repository_impl.dart';
import 'domain/repositories/balance_repository.dart';
import 'domain/use_cases/get_user_balance_use_case.dart';
import 'presentation/cubit/user_balance_cubit.dart';
import 'presentation/pages/home_page/home_page.dart';
import 'presentation/pages/wallets_page/wallets_page.dart';

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
    i.add<MyHttpClient>(_initMyHttpClient(withCache: false));
    i.add<MyHttpClient>(_initMyHttpClient(withCache: true), key: withCacheKey);

    // Data layer dependencies
    i.add(BalanceRemoteDataSourceImpl.new);

    // Domain layer dependencies
    i.add<BalanceRepository>(BalanceRepositoryImpl.new);
    i.add(GetUserBalanceUseCase.new);

    // Presentation layer dependencies
    i.addSingleton(UserBalanceCubit.new);
    i.addSingleton(floatingMenuBuilder, key: floatingMenuBuilderKey);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => HomePage());
    r.child(WalletsPage.pageRoute, child: (_) => WalletsPage());
  }
}
