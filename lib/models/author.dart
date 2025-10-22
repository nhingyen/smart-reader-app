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
}
