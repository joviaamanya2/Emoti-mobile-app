import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emoti_app/screens/splash_screen.dart';
import '../services/settings_service.dart';


// ==========================================
// GLOBAL THEME NOTIFIER
// ==========================================
class ThemeNotifier {
  // Replace 'false' with SettingsProvider.isDarkMode if you load it from SharedPreferences on startup
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(SettingsProvider.isDarkMode); 
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initial status bar for the Splash Screen before the app fully loads
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 10, 223, 70),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const EmotiApp());
}

class EmotiApp extends StatelessWidget {
  const EmotiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder listens to the theme toggle and rebuilds the MaterialApp
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Emoti',

          // This tells the app to switch between theme and darkTheme
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          // ==========================================
          // LIGHT THEME
          // ==========================================
          theme: ThemeData(
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: const Color(0xFFF3F4F6),
            primaryColor: const Color.fromARGB(255, 7, 192, 75),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black87),
              bodySmall: TextStyle(color: Colors.black54),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 7, 221, 67),
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black87),
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color.fromARGB(255, 20, 230, 79),
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
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

          // ==========================================
          // DARK THEME (Added this)
          // ==========================================
          darkTheme: ThemeData(
            fontFamily: 'Roboto',
            // Standard dark mode background
            scaffoldBackgroundColor: const Color(0xFF121212),
            // Slightly brighter green so it pops nicely on dark backgrounds
            primaryColor: const Color(0xFF4ADE80), 
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white54),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white70),
              titleTextStyle: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xFF1E1E1E),
                statusBarIconBrightness: Brightness.light, // White battery/time icons
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white, // White text on buttons in dark mode
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            // Optional: Makes cards and bottom sheets dark by default
            cardTheme: const CardThemeData(
              color: Color(0xFF1E1E1E),
              elevation: 0,
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
          ),

          // DYNAMIC STATUS BAR WRAPPER
          // This ensures the status bar color changes instantly when toggling, 
          // even on screens without an AppBar.
          builder: (context, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: isDark ? const Color(0xFF1E1E1E) : const Color.fromARGB(255, 27, 224, 83),
                statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              ),
              child: child!,
            );
          },

          // Using 'child' here prevents the SplashScreen from rebuilding unnecessarily
          home: child, 
        );
      },
      
      // The SplashScreen is passed here so it doesn't get recreated on theme change
      child: const SplashScreen(),
    );
  }
}