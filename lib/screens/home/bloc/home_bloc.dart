// import 'dart:math';
// import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_reader/models/author.dart';
// import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/home/bloc/home_event.dart';
import 'package:smart_reader/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository repository;
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final homeData = await repository.fetchHomeData();

        emit(
          HomeLoaded(
            continueReading: homeData['continueReading'],
            authors: homeData['authors'],
            newBooks: homeData['newBooks'],
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
