import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/screens/onboarding/onboarding_screen.dart';
import 'package:smart_reader/screens/login/login_screen.dart';
import 'package:smart_reader/screens/startup/app_startup_screen.dart';
import 'package:smart_reader/screens/profile/profile_screen.dart';
import 'package:smart_reader/screens/auth/bloc/auth_bloc.dart';
import 'package:smart_reader/screens/auth/bloc/auth_event.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    // App vẫn chạy được mà không cần Firebase trong development
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(CheckAuthStatusEvent()),
        ),
      ],
      child: MaterialApp(
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
        initialRoute: '/',
        routes: {
          '/': (context) => const AppStartupScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
