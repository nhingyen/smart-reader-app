class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isEmailVerified;
  final String? phone;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.lastLoginAt,
    required this.isEmailVerified,
    this.phone,
    this.preferences,
  });

  // Convert from Firebase User to UserModel
  factory UserModel.fromFirebaseUser(
    dynamic firebaseUser, {
    Map<String, dynamic>? additionalData,
  }) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoURL: firebaseUser.photoURL,
      createdAt: additionalData?['createdAt']?.toDate() ?? DateTime.now(),
      lastLoginAt: DateTime.now(),
      isEmailVerified: firebaseUser.emailVerified,
      phone: firebaseUser.phoneNumber,
      preferences: additionalData?['preferences'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'isEmailVerified': isEmailVerified,
      'phone': phone,
      'preferences': preferences ?? {},
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      lastLoginAt: map['lastLoginAt']?.toDate() ?? DateTime.now(),
      isEmailVerified: map['isEmailVerified'] ?? false,
      phone: map['phone'],
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
    );
  }

  // Copy with new values
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    String? phone,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phone: phone ?? this.phone,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName)';
  }
}
