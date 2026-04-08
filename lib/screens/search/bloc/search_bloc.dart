import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'search_event.dart';
import 'search_state.dart';
import 'package:rxdart/rxdart.dart'; // (Tùy chọn) Để debounce

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BookRepository bookRepository;

  SearchBloc({required this.bookRepository}) : super(SearchInitial()) {
    // Sử dụng transformer để Debounce (Chờ người dùng gõ xong mới gọi API)
    // Nếu chưa cài rxdart thì dùng cách gọi bình thường bên dưới cũng được
    on<SearchQueryChanged>(
      (event, emit) async {
        if (event.query.isEmpty) {
          emit(SearchInitial());
          return;
        }

        emit(SearchLoading());
        try {
          final books = await bookRepository.searchBooks(event.query);
          emit(SearchLoaded(books));
        } catch (e) {
          emit(SearchError("Lỗi tìm kiếm: $e"));
        }
      },
      transformer: (events, mapper) {
        // Chờ 500ms sau khi ngừng gõ mới gọi API (Tránh spam server)
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .asyncExpand(mapper);
      },
    );
  }
}
