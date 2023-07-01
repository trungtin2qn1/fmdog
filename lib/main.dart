import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmdog/category/category_hive_helper.dart';
import 'package:fmdog/core/theme/theme.dart';
import 'package:fmdog/di/service_locator.dart';
import 'package:fmdog/ui/bottom_navigation_state.dart';
import 'package:fmdog/utils/broadcast/broadcast_channels.dart';
import 'package:fmdog/utils/broadcast/broadcast_receiver.dart';
import 'package:fmdog/utils/currency_helper.dart';
import 'package:fmdog/utils/validation_utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<bool> darkThemeListenable = ValueNotifier(false);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await setupLocator();
  await CurrencyHelper.setSettingLevelLocale();
  CategoryHiveHelper().addCategoriesInHive();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    setBroadcastListener();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void setBroadcastListener() {
    _streamSubscription =
        BroadcastReceiver.broadcastController.stream.listen((event) {
      if (ValidationUtils.isValidString(event) &&
          event == BroadcastChannels.refreshTheme) {
        darkThemeListenable.value = !darkThemeListenable.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: darkThemeListenable,
        builder: (context, value, _) {
          ThemeMode themeMode = ThemeModeHelper.currentTheme();
          ColorScheme lightColorScheme = ColorScheme.fromSeed(
            seedColor: context.appPrimaryColor,
            primary: context.appSecondaryColor,
          );
          ColorScheme darkColorScheme = ColorScheme.fromSeed(
            seedColor: context.appPrimaryColor,
            primary: context.appSecondaryColor,
            onSurfaceVariant: context.appSecondaryColor,
            brightness: Brightness.dark,
          );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.from(
              colorScheme: lightColorScheme,
            ).copyWith(
              colorScheme: lightColorScheme,
              dialogTheme: dialogTheme(),
              appBarTheme: appBarThemeLight(lightColorScheme),
              useMaterial3: true,
              scaffoldBackgroundColor: lightColorScheme.background,
              dialogBackgroundColor: lightColorScheme.background,
              navigationBarTheme: navigationBarThemeData(lightColorScheme),
              applyElevationOverlayColor: true,
              inputDecorationTheme: inputDecorationTheme,
              elevatedButtonTheme: elevatedButtonTheme(
                context,
                lightColorScheme,
              ),
            ),
            darkTheme: ThemeData.from(
              colorScheme: darkColorScheme,
            ).copyWith(
              colorScheme: darkColorScheme,
              dialogTheme: dialogTheme(),
              appBarTheme: appBarThemeDark(darkColorScheme),
              useMaterial3: true,
              scaffoldBackgroundColor: darkColorScheme.background,
              dialogBackgroundColor: darkColorScheme.background,
              navigationBarTheme: navigationBarThemeData(darkColorScheme),
              applyElevationOverlayColor: true,
              inputDecorationTheme: inputDecorationTheme,
              elevatedButtonTheme: elevatedButtonTheme(
                context,
                darkColorScheme,
              ),
            ),
            themeMode: themeMode,
            navigatorKey: navigatorKey,
            title: 'Money',
            home: const BottomNavigationState(),
          );
        });
  }
}
