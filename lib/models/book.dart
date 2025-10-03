import 'package:smart_reader/models/chapter.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String imgUrl;
  final double rating;
  final String description;
  final List<Chapter> chapters;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imgUrl,
    required this.rating,
    required this.description,
    this.chapters = const [],
  });
}
