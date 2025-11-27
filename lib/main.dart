import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

// --- 1. IMPORT CÁC REPOSITORY VÀO ĐÂY ---
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/repositories/user_repository.dart';

// Import Screens & Blocs cũ của bạn
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/screens/onboarding/onboarding_screen.dart';
import 'package:smart_reader/screens/login/login_screen.dart';
import 'package:smart_reader/screens/startup/app_startup_screen.dart';
import 'package:smart_reader/screens/profile/profile_screen.dart';
import 'package:smart_reader/screens/auth/bloc/auth_bloc.dart';
import 'package:smart_reader/screens/auth/bloc/auth_event.dart';
import 'package:smart_reader/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // --- 2. BỌC NGOÀI CÙNG BẰNG MultiRepositoryProvider ---
    return MultiRepositoryProvider(
      providers: [
        // Cung cấp Repository cho toàn bộ App
        RepositoryProvider<BookRepository>(
          create: (context) => BookRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
      ],
      // --- 3. SAU ĐÓ MỚI ĐẾN MultiBlocProvider ---
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(CheckAuthStatusEvent()),
          ),
          // Bạn có thể thêm các Global Bloc khác ở đây nếu cần
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Book',
          theme: ThemeData(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: 'Inter',
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
      ),
    );
  }
}
