import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> props() => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final int booksRead;
  final int dayStreak;
  final int timeRead;
  final String userTitle;

  ProfileLoaded({
    required this.user,
    this.booksRead = 24,
    this.dayStreak = 7,
    this.timeRead = 42,
    this.userTitle = 'Book Enthusiast',
  });

  ProfileLoaded copyWith({
    User? user,
    int? booksRead,
    int? dayStreak,
    int? timeRead,
    String? userTitle,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      booksRead: booksRead ?? this.booksRead,
      dayStreak: dayStreak ?? this.dayStreak,
      timeRead: timeRead ?? this.timeRead,
      userTitle: userTitle ?? this.userTitle,
    );
  }

  @override
  List<Object?> props() => [user, booksRead, dayStreak, timeRead, userTitle];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> props() => [message];
}
