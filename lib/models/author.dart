class Author {
  final String authorId;
  final String authorName;
  final String authorBio;
  final String avatarUrl;

  Author({
    required this.authorId,
    required this.authorName,
    this.authorBio = "",
    this.avatarUrl = "",
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      authorId: json['_id'] ?? '',
      authorName: json['authorName'] ?? 'Không rõ tác giả',
      authorBio: json['authorBio'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
