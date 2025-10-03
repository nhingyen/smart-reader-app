import 'package:smart_reader/models/author.dart';
import 'package:smart_reader/models/book.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Book> continueReading;
  final List<Author> authors;
  final List<Book> newBooks;
  final List<Book> specialBooks;

  HomeLoaded({
    required this.continueReading,
    required this.authors,
    required this.newBooks,
    required this.specialBooks,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
