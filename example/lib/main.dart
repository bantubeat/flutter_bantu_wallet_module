import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/my_bottom_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ModularApp(
      module: WalletModule(
        floatingMenuBuilder: MyBottomNavigationBar.new,
        getAccessToken: () => Future.sync(() => ''),
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
    return MaterialApp.router(
      title: 'flutter_bantu_wallet_module example App',
      theme: ThemeData(colorSchemeSeed: const Color(0xFFE29898)),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
