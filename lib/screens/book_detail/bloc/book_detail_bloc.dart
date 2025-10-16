import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart'; // Đảm bảo import Repository
import 'book_detail_event.dart';
import 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final BookRepository repository;

  BookDetailBloc({required this.repository}) : super(BookDetailInitial()) {
    // Đăng ký hàm xử lý cho sự kiện LoadBookDetailsEvent
    on<LoadBookDetailEvent>(_onLoadBookDetails);
  }

  Future<void> _onLoadBookDetails(
    LoadBookDetailEvent event,
    Emitter<BookDetailState> emit,
  ) async {
    // 1. Phát ra trạng thái Đang tải (Loading)
    emit(BookDetailLoading());

    try {
      // 2. Gọi Repository để lấy chi tiết sách dựa trên bookId
      final book = await repository.fetchBookDetails(event.bookId.toString());

      // 3. Phát ra trạng thái Đã tải xong (Loaded) kèm theo dữ liệu sách
      emit(BookDetailLoaded(book: book));
    } catch (e) {
      // 4. Nếu có lỗi, phát ra trạng thái Lỗi (Error)
      print("BookDetailBloc Error: Không thể tải chi tiết sách: $e");
      emit(BookDetailError(message: "Lỗi Không thể tải chi tiết sách"));
    }
  }
}
