import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/reader/bloc/reader_bloc.dart';
import 'package:smart_reader/screens/reader/bloc/reader_state.dart';

class ReaderScreen extends StatelessWidget {
  final String chapterId;
  final String bookTitle;
  final String chapterTitle;

  const ReaderScreen({
    super.key,
    required this.chapterId,
    required this.bookTitle,
    required this.chapterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReaderBloc(repository: BookRepository())
            ..add(LoadChapterContentEvent(chapterId: chapterId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(context),

        bottomNavigationBar: _buildBottomCustomNav(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookTitle,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Page 24 of 156",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {
            // Hiển thị menu tùy chọn
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ReaderBloc, ReaderState>(
      builder: (context, state) {
        if (state is ReaderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ReaderLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  chapterTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                HtmlWidget(
                  state.chapter.content,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    height: 1.6, // Tăng chiều cao dòng cho dễ đọc
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is ReaderError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("Đang tải nội dung..."));
      },
    );
  }

  Widget _buildBottomCustomNav(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8.0,
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(
            height: 1.0, // Chiều cao (độ dày) của đường kẻ
            thickness: 1.0,
            color: Colors.grey[300], // Màu xám nhạt
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCustomNavItem(
                    icon: Icons.play_arrow_rounded,
                    label: "Nghe sách",
                    iconColor: const Color(0xFF28C7A0),
                    bgColor: const Color(0xFFE0F8F3),
                    onTap: () {},
                  ),
                  _buildCustomNavItem(
                    icon: Icons.description_rounded,
                    label: "Tóm tắt",
                    iconColor: const Color(0xFFF96060),
                    bgColor: const Color(0xFFFFF0F0),
                    onTap: () {},
                  ),
                  _buildCustomNavItem(
                    icon: Icons.chat_rounded,
                    label: "AI Chat",
                    iconColor: const Color(0xFFFFA940),
                    bgColor: const Color(0xFFFFF8ED),
                    onTap: () {},
                  ),
                  _buildCustomNavItem(
                    icon: Icons.settings_rounded,
                    label: "Cài đặt",
                    iconColor: const Color(0xFF505A66),
                    bgColor: const Color(0xFFF0F2F5),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomNavItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Giữ cho Column nhỏ nhất có thể
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hộp chứa icon
          Container(
            width: 42, // Kích thước hộp
            height: 42,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10), // Bo góc
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 3),
          // Text label
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 11)),
        ],
      ),
    );
  }
}
