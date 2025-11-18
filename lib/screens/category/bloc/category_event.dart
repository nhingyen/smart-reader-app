import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> props() => [];
}

class LoadCategoryEvent extends CategoryEvent {
  const LoadCategoryEvent();
}

class LoadCategoriesEvent extends CategoryEvent {
  const LoadCategoriesEvent();
}
