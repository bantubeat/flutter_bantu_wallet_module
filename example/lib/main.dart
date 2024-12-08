import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/my_bottom_navigation_bar.dart';

// TODO: Remove
const _accessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYXBpLmRldi5iYW50dWJlYXQuY29tL2FwaS9hdXRoL3JlZnJlc2giLCJpYXQiOjE3MzE1NjQzNjksImV4cCI6MTczNTQwNjEzNywibmJmIjoxNzMyOTg2OTM3LCJqdGkiOiJOZndmQzFPNnc0T2RMeldOIiwic3ViIjoiMGVjZjk1ZjQtMmNlMy00ZGUwLTg4Y2YtMGY4MmU1YTkxMmZkIn0.P5Kog5gq2ZcM_wNoQCYJrc9eLluq6TOap_7ejTB3hCw';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (!kIsWeb) {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  runApp(
    ModularApp(
      module: WalletModule(
        floatingMenuBuilder: MyBottomNavigationBar.new,
        getAccessToken: () => Future.sync(() => _accessToken),
        routes: const WalletRoutes('/'),
      ),
      child: AppWidget(),
    ),
  );
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
          title: 'flutter_bantu_wallet_module example App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF9999),
              primary: const Color(0xFFFF9999),
            ),
            textTheme: const TextTheme(),
          ),
          routerConfig: Modular.routerConfig,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      ),
    );
  }
}
