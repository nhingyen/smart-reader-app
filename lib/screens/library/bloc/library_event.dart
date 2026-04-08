abstract class LibraryEvent {}

class LoadLibraryEvent extends LibraryEvent {
  final String userId;
  LoadLibraryEvent(this.userId);
}
