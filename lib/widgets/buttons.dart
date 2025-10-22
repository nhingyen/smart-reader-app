import 'package:flutter/material.dart';
import 'package:smart_reader/theme/app_colors.dart';

class ListButtons extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const ListButtons(
    this.text,
    this.icon,
    this.onPressed, {
    super.key,
    this.isPrimary = false, // Mặc định là nút phụ
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isPrimary ? AppColors.primary : Colors.white;
    final Color foregroundColor = isPrimary
        ? AppColors.textLight
        : AppColors.primary; // Màu chữ và icon
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},

        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor, // Áp dụng màu cho Icon và Text
          elevation: 0, // Xóa đổ bóng
          side: isPrimary
              ? null // Không viền cho nút chính
              : const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ), // Viền cho nút phụ
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                // color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
