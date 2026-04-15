import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emoti_app/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// GLOBAL STATUS BAR STYLE (applies to all screens)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 90, 240, 85), // light green top bar
      statusBarIconBrightness: Brightness.dark, // battery/time icons
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const EmotiApp());
}

class EmotiApp extends StatelessWidget {
  const EmotiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emoti',

      /// APP THEME
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),

        /// Primary App Green
        primaryColor: const Color(0xFF22C55E),

        /// Better readable text globally
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
        ),

        /// AppBar styling (matches status bar)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB9F6CA),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFFB9F6CA),
            statusBarIconBrightness: Brightness.dark,
          ),
        ),

        /// Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF22C55E),
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),

      /// Start Screen
      home: const SplashScreen(),
    );
  }
}