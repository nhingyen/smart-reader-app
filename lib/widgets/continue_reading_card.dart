import 'package:flutter/material.dart';
import 'package:smart_reader/models/reading_progess.dart'; // Import model của bạn
import 'package:smart_reader/theme/app_colors.dart';

class ContinueReadingCard extends StatelessWidget {
  final ReadingProgress progress;
  final VoidCallback onTap;

  const ContinueReadingCard({
    super.key,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho đẹp
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 150, // Chiều cao ảnh chuẩn
                width: double.infinity,
                child: Stack(
                  children: [
                    // Ảnh nền
                    Positioned.fill(
                      child: Image.network(
                        progress.imgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),
                    // (Tùy chọn) Lớp phủ mờ ở đáy ảnh để hiện số chương rõ hơn
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // TÊN SÁCH
            Text(
              progress.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600, // Đậm hơn chút
                color: AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            // THÔNG TIN CHƯƠNG (Highlight màu xanh)
            Text(
              progress.chapterTitle, // Ví dụ: "Chương 5"
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.primary, // Màu xanh để biết là đang đọc dở
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
