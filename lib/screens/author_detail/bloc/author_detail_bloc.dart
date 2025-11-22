import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/author_detail/bloc/author_detail_event.dart';
import 'package:smart_reader/screens/author_detail/bloc/author_detail_state.dart';

// part 'author_detail_event.dart';
// part 'author_detail_state.dart';

class AuthorDetailBloc extends Bloc<AuthorDetailEvent, AuthorDetailState> {
  final BookRepository repository;

  AuthorDetailBloc({required this.repository}) : super(AuthorDetailInitial()) {
    on<LoadAuthorDetailEvent>((event, emit) async {
      emit(AuthorDetailLoading());
      try {
        final data = await repository.fetchAuthorDetails(event.authorId);
        emit(AuthorDetailLoaded(author: data['author'], books: data['books']));
      } catch (e) {
        emit(AuthorDetailError(e.toString()));
      }
    });
  }
}
