import 'package:equatable/equatable.dart';
import '../../../models/categories.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> props() => [];
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class CategorySelectedEvent extends HomeEvent {
  final BookCategory category;

  const CategorySelectedEvent(this.category);

  @override
  List<Object?> props() => [category];
}
