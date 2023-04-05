import 'package:dart_vlc/dart_vlc.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/controllers/settings_controller.dart';
import 'package:fitzen_frontend/controllers/tracking_controller.dart';
import 'package:fitzen_frontend/controllers/user_controller.dart';
import 'package:fitzen_frontend/views/splash_screen.dart';
import 'package:fitzen_frontend/views/tracking_screen.dart';
import 'package:fitzen_frontend/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    center: true,
    title: "FitZen",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.setResizable(false);
    await windowManager.setMaximizable(false);
    await windowManager.focus();
  });
  await localNotifier.setup(
    appName: 'FitZen',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );
  await dotenv.load(fileName: ".env");
  FirebaseAuth.initialize(dotenv.env['FIREBASE_API_KEY']!, VolatileStore());
  DartVLC.initialize();
  runApp(FitZen());
}

class FitZen extends StatelessWidget {
  const FitZen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserController>(create: (_) => UserController()),
        ChangeNotifierProvider<SettingsController>(create: (_) => SettingsController()),
        ChangeNotifierProvider<TrackingController>(create: (_) => TrackingController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kBlue,
          textTheme: GoogleFonts.dmSansTextTheme(
            TextTheme(
              headline1: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              headline2: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Color(0xff505050),
              ),
              caption: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              button: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        home: Wrapper(),
      ),
    );
  }
}
