import 'package:flutter/material.dart';
import 'package:emoti_app/screens/splash_screen.dart';
import 'package:emoti_app/screens/onboarding_screen.dart';
import 'package:emoti_app/screens/auth_screen.dart';
import 'package:emoti_app/screens/home_screen.dart';
import 'package:emoti_app/screens/emotion_dashboard.dart';
import 'package:emoti_app/screens/recommendation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/auth': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/emotion': (context) => EmotionDashboard(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/recommendations') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => RecommendationScreen(
              mood: args['mood'],
              emoji: args['emoji'],
              gradient: args['gradient'],
            ),
          );
        }
        return null;
      },
    );
  }
}
