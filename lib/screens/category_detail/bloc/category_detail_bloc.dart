import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_event.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_state.dart';

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final BookRepository repository;

  CategoryDetailBloc({required this.repository})
    : super(CategoryDetailInitial()) {
    on<LoadCategoryBooksEvent>(_onLoadCategoryBooks);
  }

  Future<void> _onLoadCategoryBooks(
    LoadCategoryBooksEvent event,
    Emitter<CategoryDetailState> emit,
  ) async {
    emit(CategoryDetailLoading());
    try {
      final books = await repository.fetchBooksByCategory(
        event.category.endpoint,
      );
      emit(CategoryDetailLoaded(category: event.category, books: books));
    } catch (e) {
      print('CategoryDetailBloc Error: $e');
      emit(CategoryDetailError(e.toString()));
    }
  }
}
