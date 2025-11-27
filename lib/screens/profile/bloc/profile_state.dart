import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_reader/models/user_stats.dart'; // Import model vừa tạo

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user; // User của Firebase (Auth info)
  final UserStats stats; // <--- THÊM DÒNG NÀY (Mongo info)

  // Getter phụ trợ để lấy title (Ví dụ)
  String get userTitle => "Thành viên tích cực";

  ProfileLoaded({
    required this.user,
    required this.stats, // <--- Yêu cầu truyền vào
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
