import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/screens/auth/bloc/auth_bloc.dart';
import 'package:smart_reader/screens/auth/bloc/auth_state.dart';
import 'package:smart_reader/screens/onboarding/onboarding_screen.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/theme/app_colors.dart';

class AppStartupScreen extends StatelessWidget {
  const AppStartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('🏠 AppStartupScreen - Current state: ${state.runtimeType}');
        if (state is AuthAuthenticated) {
          // User is already logged in, go to home
          print('🚀 Navigating to HomeScreen');
          return const HomeScreen();
        } else if (state is AuthUnauthenticated) {
          // User is not logged in, show onboarding
          print('🚀 Navigating to OnboardingScreen');
          return const OnboardingScreen();
        } else {
          // Loading state - show splash screen
          print('⏳ Showing splash screen');
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'SmartBook',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CircularProgressIndicator(color: AppColors.primary),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
