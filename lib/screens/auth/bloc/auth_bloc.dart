import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = _auth.currentUser;
    print('🔍 Checking auth status - User: ${user?.email ?? "null"}');

    if (user != null) {
      print('✅ User is authenticated: ${user.email}');
      emit(AuthAuthenticated(user: user));
    } else {
      print('❌ User is not authenticated');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      print('🔍 Starting email login...');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      print('✅ Email login successful');

      if (userCredential.user != null) {
        emit(AuthAuthenticated(user: userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Có lỗi xảy ra';
      switch (e.code) {
        case 'user-not-found':
          message = 'Không tìm thấy tài khoản với email này';
          break;
        case 'wrong-password':
          message = 'Mật khẩu không đúng';
          break;
        case 'invalid-email':
          message = 'Email không hợp lệ';
          break;
        case 'too-many-requests':
          message = 'Quá nhiều lần thử. Vui lòng thử lại sau';
          break;
        default:
          message = 'Đăng nhập thất bại: ${e.message}';
      }
      print('❌ Email login error: $message');
      emit(AuthError(message: message));
    } catch (e) {
      print('❌ General email login error: $e');
      emit(AuthError(message: 'Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      print('🔍 Starting Google Sign-In...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('❌ User cancelled Google Sign-In');
        emit(AuthUnauthenticated());
        return;
      }

      print('✅ Google user signed in: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('✅ Got Google auth tokens');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('✅ Created Firebase credential');

      final userCredential = await _auth.signInWithCredential(credential);

      print('✅ Firebase sign-in successful');

      if (userCredential.user != null) {
        emit(AuthAuthenticated(user: userCredential.user!));
      }
    } on PlatformException catch (e) {
      print('❌ PlatformException: ${e.toString()}');
      String message = 'Lỗi đăng nhập Google';
      if (e.code == 'sign_in_failed') {
        message = 'Cần cấu hình SHA-1 certificate trong Firebase Console';
      } else if (e.code == 'network_error') {
        message = 'Lỗi mạng, vui lòng thử lại';
      }
      emit(AuthError(message: message));
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      emit(AuthError(message: 'Đăng nhập Google thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      print('🔍 Starting registration...');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(event.name);

      print('✅ Registration successful');

      if (userCredential.user != null) {
        emit(AuthAuthenticated(user: userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Có lỗi xảy ra';
      switch (e.code) {
        case 'weak-password':
          message = 'Mật khẩu quá yếu';
          break;
        case 'email-already-in-use':
          message = 'Email này đã được sử dụng';
          break;
        case 'invalid-email':
          message = 'Email không hợp lệ';
          break;
        default:
          message = 'Đăng ký thất bại: ${e.message}';
      }
      print('❌ Registration error: $message');
      emit(AuthError(message: message));
    } catch (e) {
      print('❌ General registration error: $e');
      emit(AuthError(message: 'Đăng ký thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Đăng xuất thất bại: ${e.toString()}'));
    }
  }
}
