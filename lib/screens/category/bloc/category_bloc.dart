import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/category/bloc/category_event.dart';
import 'package:smart_reader/screens/category/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final BookRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final categories = await repository.fetchCategories();

      final List<CategoryWithBooks> combined = [];

      for (var cat in categories) {
        final books = await repository.fetchBooksByCategory(
          cat.endpoint,
          limit: 5,
        );
        combined.add(CategoryWithBooks(category: cat, books: books));
      }

      emit(state.copyWith(isLoading: false, categories: combined));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
