import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
      title: "5 Châu Media",
      theme: ThemeData(
        textTheme: GoogleFonts
            .robotoTextTheme(), // Sử dụng Google Fonts cho toàn bộ textTheme
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 210,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/icons/logo2.svg',
              color: Colors.deepPurpleAccent,
              height: MediaQuery.of(context).size.height*0.2,
              width: MediaQuery.of(context).size.height*0.2,
            ),
           
           richText(25)
          ],
        ),
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

   Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: '5 Châu',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: ' Media',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
