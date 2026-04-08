import 'package:smart_reader/models/book.dart';

abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Book> books;
  LibraryLoaded(this.books);
}

class LibraryError extends LibraryState {
  final String message;
  LibraryError(this.message);
}
