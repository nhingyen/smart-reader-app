import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/reading_progess.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/repositories/user_repository.dart';
import 'package:smart_reader/screens/home/bloc/home_event.dart';
import 'package:smart_reader/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Khai báo 2 cánh tay đắc lực
  final BookRepository bookRepository;
  final UserRepository userRepository;

  HomeBloc({
    required this.bookRepository,
    required this.userRepository, // 2. Bắt buộc truyền vào khi khởi tạo Bloc
  }) : super(HomeInitial()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        // --- GIAI ĐOẠN 1: ĐI CHỢ (GỌI API) ---

        // Ông BookRepo đi lấy sách chung (Không cần userId nữa)
        final bookTask = bookRepository.fetchHomeData();

        // Ông UserRepo đi lấy tiến độ (Chỉ đi nếu có userId)
        Future<List<ReadingProgress>> userTask;
        if (event.userId != null && event.userId!.isNotEmpty) {
          userTask = userRepository.fetchContinueReading(event.userId!);
        } else {
          userTask = Future.value([]); // Không có user thì xách giỏ không về
        }

        // Chờ 2 ông cùng về (Chạy song song cho nhanh)
        final results = await Future.wait([bookTask, userTask]);

        // Bóc tách dữ liệu
        final homeData = results[0] as Map<String, dynamic>; // Rau củ
        final readingProgress = results[1] as List<ReadingProgress>; // Thịt thà

        // --- GIAI ĐOẠN 2: CHẾ BIẾN (EMIT STATE) ---
        emit(
          HomeLoaded(
            readingProgress: readingProgress, // Lấy từ UserRepo
            authors: homeData['authors'], // Lấy từ BookRepo
            newBooks: homeData['newBooks'], // Lấy từ BookRepo
            specialBooks: homeData['specialBooks'],
            categories: homeData['categories'],
          ),
        );
      } catch (e) {
        print("HomeBloc Error: $e");
        emit(HomeError("Lỗi load dữ liệu: $e"));
      }
    });

    on<CategorySelectedEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final books = await bookRepository.fetchBooksByCategory(
          event.category.endpoint,
        );
        if (state is HomeLoaded) {
          final currentState = state as HomeLoaded;
          emit(
            HomeLoaded(
              readingProgress: currentState.readingProgress,
              authors: currentState.authors,
              newBooks: books, // cập nhật newBooks theo category
              specialBooks: currentState.specialBooks,
              categories: currentState.categories,
              selectedCategory: event.category,
            ),
          );
        }
      } catch (e) {
        emit(HomeError("Lỗi khi load sách theo thể loại: $e"));
      }
    });
  }
}
