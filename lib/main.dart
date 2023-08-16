import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '/Models/Data.dart';
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
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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
      ChangeNotifierProvider(create: (_) => Location_Provider())
    ], child: MyApp()));
  });
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('Message clicked from background: ${message.notification?.body}');
  //   // Xử lý thông báo ở đây (ví dụ: chuyển hướng người dùng đến màn hình cụ thể)
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        backgroundColor:
            Color(context.watch<Setting_Provider>().background_color()),
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
