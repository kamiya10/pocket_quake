import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/layout.dart';
import 'package:pocket_quake/model/eew.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Global.init();
  runApp(const MainApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (message.data["type"] == "eew") {
      Map<String, dynamic> rawEew = jsonDecode(message.data["eew"]);
      print(rawEew);
      Eew eew = Eew.fromJson(rawEew);

      await FlutterLocalNotificationsPlugin().show(
          0,
          "強震即時警報",
          "${eew.eq.loc} 發生有感地震，慎防強烈搖晃\n規模 M${eew.eq.mag} | 深度 ${eew.eq.depth} 公里",
          const NotificationDetails(
              android: AndroidNotificationDetails(
            'eew',
            'full screen channel name',
            channelDescription: 'full screen channel description',
            priority: Priority.high,
            importance: Importance.high,
            fullScreenIntent: true,
          )));
    }
  } catch (e) {
    print(e);
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => MainAppState();

  static MainAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainAppState>();
}

class MainAppState extends State<MainApp> {
  ThemeMode _themeMode = {
        "light": ThemeMode.light,
        "dark": ThemeMode.dark,
        "system": ThemeMode.system
      }[Global.preference.getString('theme')] ??
      ThemeMode.system;

  Future<void> requestNotificationPermission() async {
    final permissions = await FirebaseMessaging.instance.requestPermission();
    if (permissions.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notification permission is granted");
    } else {
      print("Notification permission is denied");
    }
  }

  Future<void> setupNotifications() async {
    await FirebaseMessaging.instance.subscribeToTopic("eew");

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    print(message.data["eew"]);
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    setupNotifications();
  }

  void changeTheme(String themeMode) {
    setState(() {
      switch (themeMode) {
        case "light":
          _themeMode = ThemeMode.light;
          break;
        case "dark":
          _themeMode = ThemeMode.dark;
          break;
        case "system":
          _themeMode = ThemeMode.system;
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) => MaterialApp(
        theme: ThemeData(
          colorScheme: lightColorScheme,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          brightness: Brightness.dark,
        ),
        themeMode: _themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Layout(),
      ),
    );
  }
}
