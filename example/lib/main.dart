import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/my_bottom_navigation_bar.dart';

// TODO: Remove
// Ben token
// const _accessToken =
//    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYXBpLmRldi5iYW50dWJlYXQuY29tL2FwaS9hdXRoL3JlZnJlc2giLCJpYXQiOjE3MzE1NjQzNjksImV4cCI6MTczNTQwNjEzNywibmJmIjoxNzMyOTg2OTM3LCJqdGkiOiJOZndmQzFPNnc0T2RMeldOIiwic3ViIjoiMGVjZjk1ZjQtMmNlMy00ZGUwLTg4Y2YtMGY4MmU1YTkxMmZkIn0.P5Kog5gq2ZcM_wNoQCYJrc9eLluq6TOap_7ejTB3hCw';

//Jully token
// const _accessToken =
//    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYXBpLmRldi5iYW50dWJlYXQuY29tL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNzM0MzM3OTE3LCJleHAiOjE3MzY3NTcxMTcsIm5iZiI6MTczNDMzNzkxNywianRpIjoiclZEVmZMNkZib0lOanE2TCIsInN1YiI6IjBiMWM1ZDA1LWIwMjYtNDA4YS1iNmMyLWNjYTMwMjQ3MTAyYiJ9.iPPMsbaYgjLEJDYX_hHdyNxhE7IpflAJZjz7CdX_VFI';

// Production token
const _accessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vYXBpLXByb2QuYmFudHViZWF0LmNvbS9hcGkvYXV0aC9sb2dpbiIsImlhdCI6MTczNTYxOTk5MywiZXhwIjoxNzM4MDM5MTkzLCJuYmYiOjE3MzU2MTk5OTMsImp0aSI6IjhadjVRZXNQQVFFeWRqSlUiLCJzdWIiOiI3ZjkwYzg4MS0zY2QzLTQ0MGUtOTRmOS0zYmVjNDNmZTExZTEifQ.bI5S8GjTCEEkKco3q5aFAOpp35zyPFoEiet7zoB9Qds';

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
        getAccessToken: () => Future.sync(() => _accessToken),
        floatingMenuBuilder: MyBottomNavigationBar.new,
        routes: WalletRoutes(''.toLowerCase()),
        isProduction: true,
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
          onGenerateTitle: (context) => tr('example', context: context),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF9999),
              primary: const Color(0xFFFF9999),
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
