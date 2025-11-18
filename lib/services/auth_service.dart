import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_reader/models/user_model.dart';
import 'package:smart_reader/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user model with Firestore data
  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      return await _userService.getUserFromFirestore(user.uid);
    } catch (e) {
      print('❌ Error getting user model: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login time
      if (credential.user != null) {
        await _userService.updateLastLogin(credential.user!.uid);
        print('✅ User signed in: ${credential.user!.email}');
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);

        // Create user model
        final userModel = UserModel.fromFirebaseUser(
          credential.user!,
          additionalData: {
            'createdAt': DateTime.now(),
            'preferences': <String, dynamic>{},
          },
        );

        // Save to Firestore
        await _userService.saveUserToFirestore(userModel);

        // Send verification email
        await credential.user!.sendEmailVerification();

        print('✅ User registered and saved: ${credential.user!.email}');
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if user exists in Firestore
        final existingUser = await _userService.getUserFromFirestore(
          userCredential.user!.uid,
        );

        if (existingUser == null) {
          // New user - save to Firestore
          final userModel = UserModel.fromFirebaseUser(
            userCredential.user!,
            additionalData: {
              'createdAt': DateTime.now(),
              'preferences': <String, dynamic>{},
            },
          );
          await _userService.saveUserToFirestore(userModel);
        } else {
          // Existing user - update last login
          await _userService.updateLastLogin(userCredential.user!.uid);
        }

        print('✅ Google sign-in successful: ${userCredential.user!.email}');
      }

      return userCredential;
    } catch (e) {
      print('❌ Google sign-in failed: $e');
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Sign out failed: $e');
      throw Exception('Đăng xuất thất bại: $e');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      // Delete user data from Firestore
      await _userService.deleteUserData(user.uid);

      // Delete Firebase Auth account
      await user.delete();

      print('✅ User account deleted successfully');
    } catch (e) {
      print('❌ Account deletion failed: $e');
      throw Exception('Không thể xóa tài khoản: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'user-disabled':
        return 'Tài khoản đã bị vô hiệu hóa';
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu (ít nhất 6 ký tự)';
      case 'operation-not-allowed':
        return 'Phương thức đăng nhập không được kích hoạt';
      case 'invalid-credential':
        return 'Thông tin đăng nhập không hợp lệ';
      case 'account-exists-with-different-credential':
        return 'Tài khoản đã tồn tại với phương thức đăng nhập khác';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng, vui lòng thử lại';
      default:
        return 'Có lỗi xảy ra: ${e.message ?? 'Unknown error'}';
    }
  }
}
