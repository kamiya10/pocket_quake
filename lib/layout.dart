import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pocket_quake/utils/extensions.dart';
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
  late PageController _pageController;
  List<Widget> bodyWidgets = [const Home(), const Reports(), const Settings()];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            _pageController.jumpToPage(currentPageIndex);
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Symbols.home_rounded),
            selectedIcon: const Icon(
              Symbols.home_rounded,
              fill: 1.0,
              weight: 600,
            ),
            label: context.l10n.viewDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Symbols.earthquake_rounded),
            selectedIcon: const Icon(
              Symbols.earthquake_rounded,
              fill: 1.0,
              weight: 600,
            ),
            label: context.l10n.viewReports,
          ),
          NavigationDestination(
            icon: const Icon(Symbols.settings_rounded),
            selectedIcon: const Icon(
              Symbols.settings_rounded,
              fill: 1.0,
              weight: 600,
            ),
            label: context.l10n.viewSettings,
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bodyWidgets,
      ),
    );
  }
}
