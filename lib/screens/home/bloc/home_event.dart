import 'package:equatable/equatable.dart';
import 'package:smart_reader/models/categories.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {}

class CategorySelectedEvent extends HomeEvent {
  final BookCategory category;
  CategorySelectedEvent(this.category);

  @override
  List<Object?> get props => [category];
}
