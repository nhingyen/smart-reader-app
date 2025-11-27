import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_reader/repositories/user_repository.dart'; // Import Repo
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository; // 1. Khai báo Repository

  // 2. Yêu cầu truyền Repository vào Constructor
  ProfileBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserInfoEvent>(_onUpdateUserInfo);
    on<LogoutUserEvent>(_onLogoutUser);
    // on<UpdateReadingStatsEvent>(_onUpdateReadingStats); // Tạm bỏ cái này, reload lại profile là tự cập nhật
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // --- 3. LẤY DỮ LIỆU THẬT TỪ MONGODB ---
        // Gọi hàm fetchUserStats mà chúng ta vừa viết ở bước trước
        final stats = await _userRepository.fetchUserStats(user.uid);

        emit(
          ProfileLoaded(
            user: user,
            stats: stats, // Truyền stats lấy được vào State
          ),
        );
      } else {
        emit(ProfileError('User not authenticated'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUserInfo(
    UpdateUserInfoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && state is ProfileLoaded) {
        if (event.displayName != null) {
          await user.updateDisplayName(event.displayName);
        }
        if (event.photoURL != null) {
          await user.updatePhotoURL(event.photoURL);
        }
        await user.reload();

        final updatedUser = _firebaseAuth.currentUser!;
        final currentState = state as ProfileLoaded;

        // Giữ nguyên stats cũ, chỉ update user info
        emit(ProfileLoaded(
          user: updatedUser,
          stats: currentState.stats,
        ));
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
