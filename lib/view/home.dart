import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:pocket_quake/utils/extensions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    requestBatteryOptimization();
  }

  void requestBatteryOptimization() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      OptimizeBattery.isIgnoringBatteryOptimizations().then((isOptimized) {
        if (!isOptimized) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(
                Symbols.battery_saver_rounded,
                size: 32,
              ),
              title: Text(
                "停用電池最佳化",
                style: TextStyle(color: context.colors.secondary),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              content: const Text(
                "為了讓程式在背景執行時不被系統限制、即時收到地震消息，我們建議您停用電池最佳化來獲取最好的使用體驗。",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  child: const Text("之後再說"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FilledButton(
                  child: const Text("設定"),
                  onPressed: () {
                    OptimizeBattery.openBatteryOptimizationSettings();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.viewDashboard),
      ),
    );
  }
}
