import 'package:flutter/foundation.dart';
import 'package:smart_reader/models/author.dart';
import 'package:smart_reader/models/book.dart';

// part of 'author_detail_bloc.dart';

@immutable
abstract class AuthorDetailState {}

class AuthorDetailInitial extends AuthorDetailState {}

class AuthorDetailLoading extends AuthorDetailState {}

class AuthorDetailLoaded extends AuthorDetailState {
  final Author author;
  final List<Book> books;

  AuthorDetailLoaded({required this.author, required this.books});
}

class AuthorDetailError extends AuthorDetailState {
  final String message;
  AuthorDetailError(this.message);
}
