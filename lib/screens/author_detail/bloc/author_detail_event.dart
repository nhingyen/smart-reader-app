import 'package:flutter/foundation.dart';
// part of 'author_detail_bloc.dart';

@immutable
abstract class AuthorDetailEvent {}

class LoadAuthorDetailEvent extends AuthorDetailEvent {
  final String authorId;
  LoadAuthorDetailEvent(this.authorId);
}
