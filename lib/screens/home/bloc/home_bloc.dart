// import 'dart:math';
// import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_reader/models/author.dart';
// import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/repositories/_mock_data.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/home/bloc/home_event.dart';
import 'package:smart_reader/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository repository;
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        //giả lập dữ liệu (sau này thay bằng MongoDB / API call)
        await Future.delayed(Duration(seconds: 1));

        final continueReading = mockBooks
            .where(
              (b) =>
                  b.bookId == "1" ||
                  b.bookId == "2" ||
                  b.bookId == "3" ||
                  b.bookId == "12",
            )
            .toList();
        final authors = mockAuthors;
        final newBooks = mockBooks
            .where((b) => b.bookId == "1" || b.bookId == "2")
            .toList();
        final specialBooks = mockBooks
            .where((b) => b.bookId == "1" || b.bookId == "2")
            .toList();

        final List<BookCategory> categories = [
          BookCategory(id: "1", name: "Văn học", endpoint: "literature"),
          BookCategory(id: "2", name: "Lãng mạn", endpoint: "romance"),
          BookCategory(id: "3", name: "Thiếu nhi", endpoint: "children"),
          BookCategory(id: "5", name: "Khoa học", endpoint: "science"),
          BookCategory(id: "5", name: "Truyện ngắn", endpoint: "short_stories"),
          BookCategory(id: "6", name: "Trinh thám", endpoint: "mystery"),
        ];

        emit(
          HomeLoaded(
            continueReading: continueReading,
            authors: authors,
            newBooks: newBooks,
            specialBooks: specialBooks,
            categories: categories,
          ),
        );
      } catch (e) {
        emit(HomeError("Lỗi load dữ liệu: $e"));
      }
    });
    on<CategorySelectedEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final books = await repository.fetchBooksByCategory(
          event.category.endpoint,
        );
        if (state is HomeLoaded) {
          final currentState = state as HomeLoaded;
          emit(
            HomeLoaded(
              continueReading: currentState.continueReading,
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
