import 'package:flutter/material.dart';
import 'package:smart_reader/screens/login/login_screen.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/screens/onboarding/widgets/slide_content_data.dart';
import 'package:smart_reader/screens/onboarding/widgets/slide_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Danh sách nội dung cho 3 slide
  final List<SlideContent> _slides = [
    SlideContent(
      image:
          'assets/images/onboarding1.png', // Thay thế bằng đường dẫn ảnh thật
      title: "Chào mừng đến với SmartBook",
      description:
          "Khám phá thư viện tri thức vô tận, nơi lưu trữ hàng ngàn đầu sách thuộc mọi thể loại.",
    ),
    SlideContent(
      image:
          'assets/images/onboarding2.png', // Thay thế bằng đường dẫn ảnh thật
      title: "Trợ lý Đọc sách AI",
      description:
          "Nghe sách nói bằng giọng đọc AI, tóm tắt nội dung tức thì và hỏi đáp mọi thứ về cuốn sách.",
    ),
    SlideContent(
      image:
          'assets/images/onboarding3.png', // Thay thế bằng đường dẫn ảnh thật
      title: "Xây dựng Tủ sách của bạn",
      description:
          "Lưu trữ, quản lý và đồng bộ sách trên mọi thiết bị. Bắt đầu hành trình đọc sách của riêng bạn ngay hôm nay.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. PageView để trượt qua các slide
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _slides.length,
              itemBuilder: (context, index) =>
                  SlideView(content: _slides[index]),
            ),

            // 2. Nút "Bỏ qua" (Skip)
            Positioned(
              top: 16,
              right: 24,
              child: TextButton(
                onPressed: _navigateToLogin,
                child: const Text(
                  "Bỏ qua",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // 3. Phần chân (Chỉ báo trang và Nút bấm)
            Positioned(
              // đặt footer gần đáy hơn để kéo các chấm indicator xuống
              bottom: 16,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 3a. Chỉ báo trang (Dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Giảm khoảng cách giữa chấm và nút để kéo chấm xuống gần nút hơn
                  const SizedBox(height: 12),

                  // 3b. Nút "Tiếp theo" / "Bắt đầu"
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == _slides.length - 1) {
                          // Đang ở slide cuối -> Bắt đầu
                          _navigateToLogin();
                        } else {
                          // Chuyển slide tiếp theo
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? "Bắt đầu"
                            : "Tiếp theo",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
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
    );
  }
}
