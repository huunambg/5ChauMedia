import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'Models/data.dart';
import '/Models/datauser.dart';
import '/Models/detailrollcall.dart';
import '/Models/location.dart';
import '/Models/notification.dart';
import '/Models/wifi.dart';
import 'Models/settings.dart';
import 'Screens/loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting('vi_VN', null).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Notification_Provider()),
      ChangeNotifierProvider(create: (_) => Setting_Provider()),
      ChangeNotifierProvider(create: (_) => DetailRollCallUser_Provider()),
      ChangeNotifierProvider(create: (_) => Wifi_Provider()),
      ChangeNotifierProvider(create: (_) => DataUser_Provider()),
      ChangeNotifierProvider(create: (_) => Data_Provider()),
      ChangeNotifierProvider(create: (_) => Location_Provider()),
    ], child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 200,
        splash: "assets/qr_code_scan.png",
        nextScreen: Loading(),
        duration: 3000,
        splashTransition: SplashTransition.scaleTransition,
      ),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('vi', ''),
      ],
    );
  }
}
