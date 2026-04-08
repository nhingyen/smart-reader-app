class Review {
  final String id;
  final String userId;
  final String comment;
  final DateTime createdAt;
  final String userName; // <--- THÊM
  final String userPhoto; // <--- THÊM

  Review({
    required this.id,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.userName, // <--- THÊM
    required this.userPhoto, // <--- THÊM
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      userId: json['userId'],
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userName: json['userName'] ??
          json['userId'].substring(0, 8), // Dùng display name hoặc UID rút gọn
      userPhoto: json['userPhoto'] ?? '', // Lấy link ảnh
    );
  }
}
