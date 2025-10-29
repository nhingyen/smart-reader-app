class BookCategory {
  final String id;
  final String name;
  final String endpoint;

  BookCategory({required this.id, required this.name, required this.endpoint});

  factory BookCategory.fromJson(Map<String, dynamic> json) {
    return BookCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Không rõ',
      endpoint: json['endpoint'] ?? '',
    );
  }
}
