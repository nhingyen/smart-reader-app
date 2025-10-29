class ChapterInfo {
  final String id;
  final String title;
  final int order;
  ChapterInfo({required this.id, required this.title, required this.order});

  // Thêm factory fromJson để đọc JSON
  factory ChapterInfo.fromJson(Map<String, dynamic> json) {
    return ChapterInfo(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Không có tiêu đề',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}
