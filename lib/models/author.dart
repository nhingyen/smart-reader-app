class Author {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;

  Author({
    required this.id,
    required this.name,
    this.bio = "",
    this.avatarUrl = "",
  });
}
