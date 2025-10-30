class BookCategory {
  final String id;
  final String categoryName;
  final String endpoint;

  BookCategory({
    required this.id,
    required this.categoryName,
    required this.endpoint,
  });

  factory BookCategory.fromJson(Map<String, dynamic> json) {
    return BookCategory(
      id: json['_id'] ?? '',
      categoryName: json['categoryName'] ?? 'Không rõ',
      endpoint: json['endpoint'] ?? '',
    );
  }
}
