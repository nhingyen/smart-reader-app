import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/user_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final UserRepository userRepository;

  LibraryBloc({required this.userRepository}) : super(LibraryInitial()) {
    on<LoadLibraryEvent>((event, emit) async {
      emit(LibraryLoading());
      try {
        final books = await userRepository.fetchLibrary(event.userId);
        if (books.isNotEmpty) {
          emit(LibraryLoaded(books));
        } else {
          // Trả về list rỗng vẫn là Loaded (nhưng UI sẽ hiện "Trống")
          emit(LibraryLoaded([]));
        }
      } catch (e) {
        emit(LibraryError("Lỗi tải thư viện: $e"));
      }
    });
  }
}
