import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'widgets/my_bottom_navigation_bar.dart';

// test token
const _accessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYXBpLmRldi5iYW50dWJlYXQuY29tL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNzg1NzYzOTI1LCJleHAiOjE3ODgxODMxMjUsIm5iZiI6MTc4NTc2MzkyNSwianRpIjoiaklIT1JYZ3BYTWo2cDU3bSIsInN1YiI6IjdkNWQ0ZjE2LTU5OTgtNDY3YS04MTFkLTVjZDc4NTZhMTg2ZCJ9.mnEvIoecwt8EUi1hnS5RMQkZPvbg_t2ZAsB9urGH0Hc';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (!kIsWeb) {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  runApp(
    ModularApp(
      module: AppModule(),
      child: AppWidget(),
    ),
  );
}

final class MyWalletApiKeys extends WalletApiKeys {
  const MyWalletApiKeys({required super.isProduction});

  @override
  String getFlutterwavePublicKey() {
    return dotenv.get(
      isProduction ? 'LIVE_FLUTTERWAVE_PUB_KEY' : 'TEST_FLUTTERWAVE_PUB_KEY',
    );
  }

  @override
  String getPaypalClientID() {
    return dotenv.get(
      isProduction ? 'LIVE_PAYPAL_CLIENT_ID' : 'TEST_PAYPAL_CLIENT_ID',
    );
  }

  @override
  String getStripePublishableKey() {
    return dotenv.get(
      isProduction
          ? 'LIVE_STRIPE_PUBLISHABLE_KEY'
          : 'TEST_STRIPE_PUBLISHABLE_KEY',
    );
  }
}

class AppWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const supportedLocales = [Locale('en')];
    return EasyLocalization(
      path: kIsWeb ? 'i18n' : 'assets/i18n',
      saveLocale: false,
      useOnlyLangCode: true,
      useFallbackTranslations: kReleaseMode,
      supportedLocales: supportedLocales,
      fallbackLocale: supportedLocales.first,
      child: Builder(
        builder: (context) => MaterialApp.router(
          onGenerateTitle: (context) => tr('example', context: context),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFF9BF0D),
              primary: const Color(0xFFF9BF0D),
              // seedColor: const Color(0xFFFF9999),
              // primary: const Color(0xFFFF9999),
            ),
            textTheme: const TextTheme(),
          ),
          routerConfig: Modular.routerConfig,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            ...context.localizationDelegates,
            BantuWalletLocalization.getDelegate(
              context.locale,
              context.supportedLocales,
            ),
          ],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: BantuWalletLocalization.init,
        ),
      ),
    );
  }
}

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    const isProduction = false;
    r.redirect('/', to: '/wallet/home');
    r.module(
      '/wallet',
      module: WalletModule(
        onCloseModule: () {},
        getAccessToken: () => Future.sync(() => _accessToken),
        floatingMenuBuilder: MyBottomNavigationBar.new,
        routes: WalletRoutes('/wallet'.toLowerCase()),
        walletApiKeys: const MyWalletApiKeys(isProduction: isProduction),
        isProduction: isProduction,
        onGoToKycForm: () {
          debugPrint('onGoToKycForm called');
          Modular.to.navigate(Modular.initialRoute);
        },
      ),
    );
  }
}
