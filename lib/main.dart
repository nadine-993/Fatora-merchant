import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/app_theme.dart';
import 'package:fatora/core/constants/constants.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'core/constants/app_keys.dart';
import 'core/notification/notification.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'core/pages/authentication_page.dart';
import 'core/utils/di.dart';
import 'core/utils/service_locator.dart';
import 'core/utils/shared_perefrences/shared_perefrences_helper.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/on_boarding/presentation/pages/on_boarding_pages.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

final AppPreferences _appPreferences = instance<AppPreferences>();
int _counter = 0;
List<String?>? myList;

class Startup {
  static Future<void> setup() async {
    ServiceLocator.registerModels();
    await Messaging.initFCM();
  }
}

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Startup.setup();

  await EasyLocalization.ensureInitialized();
  await initAppModule();

  Locale? startLocale;
  _appPreferences.setLanguage(Constants.defaultLanguage);
  startLocale = Constants.languages[Constants.defaultLanguage];

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(
    EasyLocalization(
        startLocale: startLocale,
        supportedLocales: Constants.languages.values.toList(),
        path: "assets/lang",
        child: const Responsive()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppPreferences _appPreferences = instance<AppPreferences>();


  Future<void> _goToAuthPage() async {
    Navigation.push(AppKeys.navigatorKey.currentContext ?? context, const AuthenticationPage(fromResume: true,));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if(_appPreferences.getFingerprint()) {
        _goToAuthPage();
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InAppNotification(
      child: MaterialApp(
        navigatorKey: AppKeys.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Fatora Merchant',
        theme: getLightTheme(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: _buildHome(context),
      ),
    );
  }
}

Widget _buildHome(BuildContext context) {
  if (!_appPreferences.isOnBoardingScreenViewed()) {
    _appPreferences.setOnBoardingScreenViewed();
    return const OnBoardingPages();
  } else if (_appPreferences.hasAccessToken()) {
    return const SplashScreen();
  } else {
    return const LoginPage();
  }
}

class Responsive extends StatelessWidget {
  const Responsive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) => const MyApp(),
    );
  }
}





