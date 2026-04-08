import 'package:flutter/material.dart';
import 'package:smart_reader/theme/app_colors.dart';

class BookCard extends StatelessWidget {
  final String bookId;
  final String title;
  final String imgUrl;
  final VoidCallback onTap;

  const BookCard(
    this.bookId,
    this.title,
    this.imgUrl,
    this.onTap, {
    super.key,
    // required Book book,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // bo góc
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(imgUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
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
