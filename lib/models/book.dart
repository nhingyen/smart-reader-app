import 'package:smart_reader/models/chapter.dart';

class Book {
  final String bookId;
  final String title;
  final String authorId;
  final String authorName;
  final String imgUrl;
  final double rating;
  final String description;
  final List<Chapter> chapters;
  final double ratingCount;
  final double chapterCount;
  final List genres;
  final bool isAddedToLibrary;

  Book({
    required this.bookId,
    required this.title,
    required this.authorId,
    required this.authorName,
    required this.imgUrl,
    required this.rating,
    required this.description,
    this.chapters = const [],
    required this.ratingCount,
    required this.chapterCount,
    this.genres = const [],
    required this.isAddedToLibrary,
  });
}
