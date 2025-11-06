import 'package:smart_reader/models/chapter_detail.dart';

abstract class ReaderState {}

class ReaderInitial extends ReaderState {}

class ReaderLoading extends ReaderState {}

class ReaderLoaded extends ReaderState {
  final ChapterDetail chapter;

  ReaderLoaded({required this.chapter});
}

class ReaderError extends ReaderState {
  final String message;
  ReaderError({required this.message});
}
