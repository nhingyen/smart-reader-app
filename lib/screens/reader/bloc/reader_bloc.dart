import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/reader/bloc/reader_state.dart';

part 'reader_event.dart';
// part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final BookRepository repository;

  ReaderBloc({required this.repository}) : super(ReaderInitial()) {
    on<LoadChapterContentEvent>(_onLoadChapterContent);
  }

  Future<void> _onLoadChapterContent(
    LoadChapterContentEvent event,
    Emitter<ReaderState> emit,
  ) async {
    emit(ReaderLoading());
    try {
      final chapter = await repository.fetchChapterContent(event.chapterId);
      emit(ReaderLoaded(chapter: chapter));
    } catch (e) {
      print("ReaderBloc Error: $e");
      emit(ReaderError(message: "Lỗi khi tải nội dung chương: $e"));
    }
  }
}
