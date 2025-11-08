import 'package:flutter/material.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/screens/onboarding/onboarding_screen.dart';
import 'package:smart_reader/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Book',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter', // Bạn cần thêm font này vào pubspec.yaml
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.primary),
          bodyMedium: TextStyle(color: AppColors.secondary),
        ),
      ),
      home: const OnboardingScreen(),
      // home: const HomeScreen(),
      // home: const VideoDownloadScreen(),
      // home: const VideoScreen(),
    );
  }
}
