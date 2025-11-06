part of 'reader_bloc.dart';

abstract class ReaderEvent {}

class LoadChapterContentEvent extends ReaderEvent {
  final String chapterId;
  LoadChapterContentEvent({required this.chapterId});
}
