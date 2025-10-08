import 'package:equatable/equatable.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';

abstract class CategoryDetailEvent extends Equatable {
  const CategoryDetailEvent();

  @override
  List<Object> props() => [];
}

class LoadCategoryBooksEvent extends CategoryDetailEvent {
  final BookCategory category;

  LoadCategoryBooksEvent(this.category);

  @override
  List<Object> props() => [category];
}
