import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:smart_reader/screens/onboarding/bloc/onboarding_event.dart';
import 'package:smart_reader/screens/onboarding/bloc/onboarding_state.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/screens/onboarding/widgets/slide_content_data.dart';
import 'package:smart_reader/screens/onboarding/widgets/slide_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            // Navigate to login screen when onboarding is completed
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        child: const _OnboardingScreenContent(),
      ),
    );
  }
}

class _OnboardingScreenContent extends StatefulWidget {
  const _OnboardingScreenContent();

  @override
  State<_OnboardingScreenContent> createState() =>
      _OnboardingScreenContentState();
}

class _OnboardingScreenContentState extends State<_OnboardingScreenContent> {
  final PageController _pageController = PageController();

  // Danh sách nội dung cho 3 slide
  final List<SlideContent> _slides = [
    SlideContent(
      image: 'assets/images/onboarding1.png',
      title: "Chào mừng đến với SmartBook",
      description:
          "Khám phá thư viện tri thức vô tận, nơi lưu trữ hàng ngàn đầu sách thuộc mọi thể loại.",
    ),
    SlideContent(
      image: 'assets/images/onboarding2.png',
      title: "Trợ lý Đọc sách AI",
      description:
          "Nghe sách nói bằng giọng đọc AI, tóm tắt nội dung tức thì và hỏi đáp mọi thứ về cuốn sách.",
    ),
    SlideContent(
      image: 'assets/images/onboarding3.png',
      title: "Xây dựng Tủ sách của bạn",
      description:
          "Lưu trữ, quản lý và đồng bộ sách trên mọi thiết bị. Bắt đầu hành trình đọc sách ngay.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<OnboardingBloc>().add(GoToPageEvent(index));
  }

  void _nextPage() {
    context.read<OnboardingBloc>().add(NextPageEvent());
  }

  void _skip() {
    context.read<OnboardingBloc>().add(CompleteOnboardingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingPageState) {
            // Animate to the new page when state changes
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        builder: (context, state) {
          if (state is OnboardingPageState) {
            return SafeArea(
              child: Column(
                children: [
                  // Skip button - hiển thị ở tất cả các trang
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: _skip,
                        child: Text(
                          'Bỏ qua',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        return SlideView(content: _slides[index]);
                      },
                    ),
                  ),
                  // Bottom section with indicators and buttons
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Page indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            state.totalPages,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: index == state.currentPage ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index == state.currentPage
                                    ? AppColors.primary
                                    : AppColors.greyLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Giảm từ 32 xuống 16
                        // Navigation buttons - center layout
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: state.currentPage < 2
                              ? // For slides 1 & 2: Center "Tiếp theo" button
                                Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _nextPage,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Tiếp theo',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : // For slide 3: "Quay lại" and "Bắt đầu"
                                Row(
                                  children: [
                                    // // Previous button
                                    // Expanded(
                                    //   child: OutlinedButton(
                                    //     onPressed: _previousPage,
                                    //     style: OutlinedButton.styleFrom(
                                    //       side: BorderSide(
                                    //         color: AppColors.primary,
                                    //       ),
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(
                                    //           12,
                                    //         ),
                                    //       ),
                                    //       padding: const EdgeInsets.symmetric(
                                    //         vertical: 16,
                                    //       ),
                                    //     ),
                                    //     child: Text(
                                    //       'Quay lại',
                                    //       style: TextStyle(
                                    //         color: AppColors.primary,
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.w600,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(width: 16),
                                    // Get Started button
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _nextPage,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'Bắt đầu',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Fallback loading state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
