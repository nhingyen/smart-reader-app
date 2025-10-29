class ChapterDetail {
  final String id;
  final String title;
  final String content; // nội dung chương (text / HTML)
  // final int order; // số thứ tự chương

  ChapterDetail({
    required this.id,
    required this.title,
    required this.content,
    // required this.order,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Không có tiêu đề',
      content: json['content'] ?? '<p>Không có nội dung.</p>',
    );
  }
}
