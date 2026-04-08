class ReadingProgress {
  final String id;
  final String bookId;
  final String chapterId;
  final String title;
  final String imgUrl;
  final String authorName;
  final String chapterTitle;
  final String lastReadAt;

  ReadingProgress({
    required this.id,
    required this.bookId,
    required this.chapterId,
    required this.title,
    required this.imgUrl,
    required this.authorName,
    required this.chapterTitle,
    required this.lastReadAt,
  });

  // Factory parse từ JSON lồng nhau
  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    final bookObj = json['bookId'] ?? {};
    final authorObj = bookObj['author'] ?? {};
    final chapterObj = json['chapterId'] ?? {};

    return ReadingProgress(
      id: json['_id'] ?? '',
      // Lưu ý: bookId trong JSON trả về là Object, nhưng ta chỉ cần lấy ID để dùng sau này
      bookId: bookObj['_id'] ?? '',
      chapterId: chapterObj['_id'] ?? '',
      title: bookObj['title'] ?? 'Không tên',
      // Dùng imgUrl như kết quả API trả về
      imgUrl: bookObj['imgUrl'] ?? 'https://via.placeholder.com/150',
      authorName: authorObj['authorName'] ?? 'Tác giả ẩn danh',
      chapterTitle: chapterObj['title'] ?? 'Chương mở đầu',
      lastReadAt: json['lastReadAt'] ?? '',
    );
  }
}
