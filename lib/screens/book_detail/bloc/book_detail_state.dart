import 'package:equatable/equatable.dart';
import 'package:smart_reader/models/book.dart';

abstract class BookDetailState extends Equatable {
  const BookDetailState();

  @override
  List<Object?> props() => [];
}

class BookDetailInitial extends BookDetailState {}

class BookDetailLoading extends BookDetailState {}

class BookDetailLoaded extends BookDetailState {
  final Book book;

  BookDetailLoaded({required this.book});

  @override
  List<Object?> props() => [book];
}

class BookDetailError extends BookDetailState {
  final String message;

  BookDetailError({required this.message});

  @override
  List<Object?> props() => [message];
}
