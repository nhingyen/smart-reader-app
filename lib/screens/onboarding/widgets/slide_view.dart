import 'package:flutter/material.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/screens/onboarding/widgets/slide_content_data.dart';

class SlideView extends StatelessWidget {
  final SlideContent content;

  const SlideView({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Image section - đẩy lên sát "Bỏ qua"
          Expanded(
            flex: 3, // Giảm từ 4 xuống 3 để tiết kiệm không gian
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 280, // Giảm từ 300 xuống 280
                    height: 280, // Giảm từ 300 xuống 280
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Bo tròn cho hình ảnh bên trong
                        child: Image.asset(
                          content.image,
                          fit: BoxFit
                              .cover, // Đổi từ contain sang cover để đầy container
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  size: 80,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8), // Giảm từ 16 xuống 8
          // Content section
          Expanded(
            flex: 2, // Giảm flex từ 3 xuống 2
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22, // Giảm font size một chút
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8), // Giảm từ 12 xuống 8
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    content.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15, // Giảm font size một chút
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom spacing for buttons - giảm flex
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
