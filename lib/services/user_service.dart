import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reader/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Lưu hoặc cập nhật thông tin user vào Firestore
  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));

      print('✅ User saved to Firestore: ${user.displayName}');
    } catch (e) {
      print('❌ Error saving user to Firestore: $e');
      throw Exception('Không thể lưu thông tin người dùng: $e');
    }
  }

  // Lấy thông tin user từ Firestore
  Future<UserModel?> getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user from Firestore: $e');
      throw Exception('Không thể lấy thông tin người dùng: $e');
    }
  }

  // Cập nhật last login time
  Future<void> updateLastLogin(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ Error updating last login: $e');
    }
  }

  // Cập nhật user preferences
  Future<void> updateUserPreferences(
    String uid,
    Map<String, dynamic> preferences,
  ) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'preferences': preferences,
      });

      print('✅ User preferences updated');
    } catch (e) {
      print('❌ Error updating preferences: $e');
      throw Exception('Không thể cập nhật cài đặt: $e');
    }
  }

  // Cập nhật profile user
  Future<void> updateUserProfile(
    String uid, {
    String? displayName,
    String? photoURL,
    String? phone,
  }) async {
    try {
      Map<String, dynamic> updates = {};

      if (displayName != null) updates['displayName'] = displayName;
      if (photoURL != null) updates['photoURL'] = photoURL;
      if (phone != null) updates['phone'] = phone;

      if (updates.isNotEmpty) {
        await _firestore.collection(_usersCollection).doc(uid).update(updates);

        print('✅ User profile updated');
      }
    } catch (e) {
      print('❌ Error updating user profile: $e');
      throw Exception('Không thể cập nhật thông tin: $e');
    }
  }

  // Xóa user data (GDPR compliance)
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();

      print('✅ User data deleted');
    } catch (e) {
      print('❌ Error deleting user data: $e');
      throw Exception('Không thể xóa dữ liệu người dùng: $e');
    }
  }

  // Stream để theo dõi thay đổi user data
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection(_usersCollection).doc(uid).snapshots().map((
      doc,
    ) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Kiểm tra user có tồn tại không
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('❌ Error checking user existence: $e');
      return false;
    }
  }

  // Lấy danh sách users (cho admin)
  Future<List<UserModel>> getAllUsers({
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(_usersCollection)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error getting all users: $e');
      throw Exception('Không thể lấy danh sách người dùng: $e');
    }
  }

  // Tìm kiếm user theo email
  Future<UserModel?> findUserByEmail(String email) async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromMap(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('❌ Error finding user by email: $e');
      throw Exception('Không thể tìm người dùng: $e');
    }
  }
}
