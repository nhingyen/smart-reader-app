import 'package:smart_reader/models/book.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {} // Mới vào chưa tìm gì

class SearchLoading extends SearchState {} // Đang xoay

class SearchLoaded extends SearchState {
  final List<Book> books;
  SearchLoaded(this.books);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
