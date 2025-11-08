import 'package:flutter/material.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/screens/onboarding/widgets/slide_content_data.dart';

// Widget này chịu trách nhiệm hiển thị nội dung của 1 slide
class SlideView extends StatelessWidget {
  final SlideContent content;

  const SlideView({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        // Start from top so the image sits below the top-positioned "Bỏ qua" button
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Small dynamic top spacing so content sits under the status bar / skip button
          const SizedBox(height: 56),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              content.image,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Nếu không load được ảnh, vẫn hiển thị placeholder dễ hiểu
                return Container(
                  height: 250,
                  width: 250,
                  color: AppColors.greyLight.withOpacity(0.3),
                  child: Center(
                    child: Text(
                      "Không tìm thấy ảnh minh họa",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.secondary),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),

          // 2. Tiêu đề
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),

          // 3. Mô tả
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textDark,
              height: 1.5, // Giãn dòng
            ),
          ),

          // Dùng khoảng cách cố định nhỏ để đẩy nội dung lên — sẽ làm footer (dots/button)
          // xuất hiện thấp hơn trên màn hình.
          const SizedBox(height: 24),        ],
      ),
    );
  }
}
