class UserStats {
  final int booksRead;
  final int dayStreak;
  final int totalMinutes;

  UserStats({
    required this.booksRead,
    required this.dayStreak,
    required this.totalMinutes,
  });

  // Factory để parse từ JSON Backend trả về
  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      booksRead: json['booksRead'] ?? 0,
      dayStreak: json['dayStreak'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
    );
  }

  // Tạo data mặc định khi chưa có dữ liệu
  factory UserStats.empty() {
    return UserStats(booksRead: 0, dayStreak: 0, totalMinutes: 0);
  }
}
