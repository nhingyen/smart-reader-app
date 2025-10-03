class Chapter {
  final String id;
  final String title;
  final String content; // nội dung chương (text / HTML)
  final int order; // số thứ tự chương

  Chapter({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
  });
}
