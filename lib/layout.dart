import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pocket_quake/view/home.dart';
import 'package:pocket_quake/view/reports.dart';
import 'package:pocket_quake/view/settings.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<StatefulWidget> createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  int currentPageIndex = 0;

  List<Widget> bodyWidgets = [const Home(), const Reports(), const Settings()];
  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
              icon: const Icon(Symbols.home_rounded),
              selectedIcon: const Icon(Symbols.home_rounded, fill: 1.0),
              label: AppLocalizations.of(context)!.viewDashboard,
            ),
            NavigationDestination(
              icon: const Icon(Symbols.earthquake_rounded),
              selectedIcon: const Icon(Symbols.earthquake_rounded, fill: 1.0),
              label: AppLocalizations.of(context)!.viewReports,
            ),
            NavigationDestination(
              icon: const Icon(Symbols.settings_rounded),
              selectedIcon: const Icon(Symbols.settings_rounded, fill: 1.0),
              label: AppLocalizations.of(context)!.viewSettings,
            )
          ],
        ),
        body: bodyWidgets[currentPageIndex],
      );
}
