import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  static const int _totalPages = 3;
  int _currentPage = 0;

  OnboardingBloc()
    : super(
        const OnboardingPageState(
          currentPage: 0,
          totalPages: _totalPages,
          isLastPage: false,
        ),
      ) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<GoToPageEvent>(_onGoToPage);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  void _onNextPage(NextPageEvent event, Emitter<OnboardingState> emit) {
    if (_currentPage < _totalPages - 1) {
      _currentPage++;
      emit(
        OnboardingPageState(
          currentPage: _currentPage,
          totalPages: _totalPages,
          isLastPage: _currentPage == _totalPages - 1,
        ),
      );
    } else {
      emit(OnboardingCompleted());
    }
  }

  void _onPreviousPage(PreviousPageEvent event, Emitter<OnboardingState> emit) {
    if (_currentPage > 0) {
      _currentPage--;
      emit(
        OnboardingPageState(
          currentPage: _currentPage,
          totalPages: _totalPages,
          isLastPage: false,
        ),
      );
    }
  }

  void _onGoToPage(GoToPageEvent event, Emitter<OnboardingState> emit) {
    if (event.pageIndex >= 0 && event.pageIndex < _totalPages) {
      _currentPage = event.pageIndex;
      emit(
        OnboardingPageState(
          currentPage: _currentPage,
          totalPages: _totalPages,
          isLastPage: _currentPage == _totalPages - 1,
        ),
      );
    }
  }

  void _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingCompleted());
  }
}
