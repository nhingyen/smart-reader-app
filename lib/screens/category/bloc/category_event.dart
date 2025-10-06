import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {}

class LoadCategoryEvent extends CategoryEvent {
  @override
  List<Object?> props() => [];
}

class LoadCategoriesEvent extends CategoryEvent {
  @override
  List<Object?> props() => [];
}
