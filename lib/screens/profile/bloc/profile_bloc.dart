import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateReadingStatsEvent>(_onUpdateReadingStats);
    on<UpdateUserInfoEvent>(_onUpdateUserInfo);
    on<LogoutUserEvent>(_onLogoutUser);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Load user profile data
        // In a real app, you would fetch this from a database
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate loading

        emit(
          ProfileLoaded(
            user: user,
            booksRead: 24,
            dayStreak: 7,
            timeRead: 42,
            userTitle: 'Book Enthusiast',
          ),
        );
      } else {
        emit(ProfileError('User not authenticated'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateReadingStats(
    UpdateReadingStatsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(
        currentState.copyWith(
          booksRead: event.booksRead,
          dayStreak: event.dayStreak,
          timeRead: event.timeRead,
        ),
      );
    }
  }

  Future<void> _onUpdateUserInfo(
    UpdateUserInfoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && state is ProfileLoaded) {
        // Update user info in Firebase
        if (event.displayName != null) {
          await user.updateDisplayName(event.displayName);
        }
        if (event.photoURL != null) {
          await user.updatePhotoURL(event.photoURL);
        }
        await user.reload();

        final updatedUser = _firebaseAuth.currentUser!;
        final currentState = state as ProfileLoaded;
        emit(currentState.copyWith(user: updatedUser));
      }
    } catch (e) {
      emit(ProfileError('Failed to update user info: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutUser(
    LogoutUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _firebaseAuth.signOut();
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError('Failed to logout: ${e.toString()}'));
    }
  }
}
