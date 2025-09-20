import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'widgets/my_bottom_navigation_bar.dart';

// Ben token
const _accessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYXBpLmRldi5iYW50dWJlYXQuY29tL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNzU4Mzc4Mjc1LCJleHAiOjE3NjA3OTc0NzUsIm5iZiI6MTc1ODM3ODI3NSwianRpIjoiVVQ0YlJiNlU3UTRPRzJXeSIsInN1YiI6IjBlY2Y5NWY0LTJjZTMtNGRlMC04OGNmLTBmODJlNWE5MTJmZCJ9.e2oZWrQavG8XOYVDC5G_rzL6O1RYIT0GYYR0uBDZyOQ';

// Production token
//const _accessToken =
//    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYXBpLXByb2QuYmFudHViZWF0LmNvbS9hcGkvYXV0aC9sb2dpbiIsImlhdCI6MTczNTYxOTk5MywiZXhwIjoxNzM4MDM5MTkzLCJuYmYiOjE3MzU2MTk5OTMsImp0aSI6IjhadjVRZXNQQVFFeWRqSlUiLCJzdWIiOiI3ZjkwYzg4MS0zY2QzLTQ0MGUtOTRmOS0zYmVjNDNmZTExZTEifQ.bI5S8GjTCEEkKco3q5aFAOpp35zyPFoEiet7zoB9Qds';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (!kIsWeb) {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  const isProduction = false;
  runApp(
    ModularApp(
      // module: WalletModule(
      //   getAccessToken: () => Future.sync(() => _accessToken),
      //   floatingMenuBuilder: MyBottomNavigationBar.new,
      //   routes: WalletRoutes(''.toLowerCase()),
      //   walletApiKeys: const MyWalletApiKeys(isProduction: isProduction),
      //   isProduction: isProduction,
      // ),
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
    const supportedLocales = [Locale('fr')];
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
        getAccessToken: () => Future.sync(() => _accessToken),
        floatingMenuBuilder: MyBottomNavigationBar.new,
        routes: WalletRoutes('/wallet'.toLowerCase()),
        walletApiKeys: const MyWalletApiKeys(isProduction: isProduction),
        isProduction: isProduction,
        onGoToKycForm: () {
          print('onGoToKycForm called');
          Modular.to.navigate(Modular.initialRoute);
        },
      ),
    );
  }
}
