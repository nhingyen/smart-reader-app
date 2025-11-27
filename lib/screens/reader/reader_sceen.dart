import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smart_reader/models/chapter_info.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/repositories/user_repository.dart';
import 'package:smart_reader/screens/reader/bloc/reader_bloc.dart';
import 'package:smart_reader/screens/reader/bloc/reader_state.dart';

class ReaderScreen extends StatefulWidget {
  final String bookId;
  final String chapterId;
  final String bookTitle;
  final String chapterTitle;
  final List<ChapterInfo> allChapters;
  final int currentChapterIndex;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.chapterId,
    required this.bookTitle,
    required this.chapterTitle,
    required this.allChapters,
    required this.currentChapterIndex,
  });
  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  // 1. Biến đo thời gian
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    // Bắt đầu tính giờ khi vào màn hình
    _startTime = DateTime.now();
  }

  // 2. Hàm gọi API cập nhật thống kê
  Future<void> _updateStats() async {
    if (_startTime == null) return;

    final minutes = DateTime.now().difference(_startTime!).inMinutes;
    // Tạm thời comment dòng này để test cho dễ (đọc vài giây cũng tính)
    // if (minutes < 1) return;

    // === KIỂM TRA LOGIC CHƯƠNG CUỐI ===
    // Index hiện tại (bắt đầu từ 0)
    int currentIndex = widget.currentChapterIndex;
    // Tổng số chương
    int totalChapters = widget.allChapters.length;

    // Điều kiện: Index hiện tại == (Tổng - 1)
    final isLastChapter = currentIndex == (totalChapters - 1);

    print("---------------- DEBUG STATS ----------------");
    print("User: ${FirebaseAuth.instance.currentUser?.uid}");
    print("Sách ID: ${widget.bookId}");
    print("Phút đọc: $minutes");
    print("Chương hiện tại: $currentIndex / ${totalChapters - 1}");
    print("👉 ĐÃ XONG SÁCH CHƯA?: $isLastChapter");
    print("---------------------------------------------");

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await context.read<UserRepository>().updateReadingStats(
            userId: user.uid,
            bookId: widget.bookId, // Đảm bảo trường này không null
            minutesRead: minutes,
            isBookFinished: isLastChapter,
          );
    }
  }

  // 3. Gọi hàm này khi thoát (PopScope)
  // Trong hàm build, chỗ PopScope bạn đã làm ở bài trước:
  /*
  onPopInvoked: (didPop) async {
      if (didPop) {
          _saveProgress(); // Lưu vị trí
          await _updateStats(); // <--- GỌI THÊM HÀM NÀY
      }
  }
  */
  // Hàm lưu tiến độ xuống Database
  void _saveProgress() {
    final user = FirebaseAuth.instance.currentUser;
// 1. Tính thời gian
    final minutes = DateTime.now().difference(_startTime!).inMinutes;

    // Chỉ lưu nếu đã đăng nhập
    if (user != null) {
      print(
        "Đang lưu tiến độ: Book ${widget.bookId} - Chap ${widget.chapterId}",
      );

      // Gọi Repository (đã inject ở main.dart)
      context.read<UserRepository>().saveReadingProgress(
            userId: user.uid,
            bookId: widget.bookId,
            chapterId: widget.chapterId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReaderBloc(repository: BookRepository())
        ..add(LoadChapterContentEvent(chapterId: widget.chapterId)),
      child: PopScope(
        canPop: true, // Cho phép thoát màn hình bình thường
        onPopInvoked: (didPop) {
          if (didPop) {
            // Khi thoát thành công (vuốt back hoặc nút back hệ thống)
            // Gọi hàm lưu lại tiến độ
            _saveProgress();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: _buildBody(context),
          bottomNavigationBar: _buildBottomCustomNav(context),
        ),
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
        onPressed: () async {
          // Gọi hàm tính toán thống kê trước
          await _updateStats();
          _saveProgress(); // Lưu trước
          // Sau khi xử lý xong mới thoát màn hình
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bookTitle,
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
                  widget.chapterTitle,
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

                // === 3. THÊM WIDGET MỚI (NÚT LẬT TRANG) ===
                _buildChapterNavigation(context),
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

  Widget _buildChapterNavigation(BuildContext context) {
    //kiem tra xem co chuong truoc khogn
    final bool hasPrevious = widget.currentChapterIndex > 0;
    //kiem tra xem co chuong sau ko
    final bool hasNext =
        widget.currentChapterIndex < widget.allChapters.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasPrevious)
          TextButton(
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios, size: 13, color: Colors.black),
                SizedBox(width: 3),
                Text(
                  "Chương trước",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
            onPressed: () {
              final prevChapter =
                  widget.allChapters[widget.currentChapterIndex - 1];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ReaderScreen(
                    bookId: widget.bookId,
                    chapterId: prevChapter.id,
                    bookTitle: widget.bookTitle,
                    chapterTitle: prevChapter.title,
                    allChapters: widget.allChapters,
                    currentChapterIndex: widget.currentChapterIndex - 1,
                  ),
                ),
              );
            },
          )
        else
          Container(), // Để trống nếu không có chương trước
        // NÚT CHƯƠNG SAU
        if (hasNext)
          TextButton(
            child: Row(
              children: [
                Text(
                  "Chương sau",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(width: 3),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 13,
                  color: Colors.black,
                ),
              ],
            ),
            onPressed: () {
              // Lấy thông tin chương sau
              final nextChapter =
                  widget.allChapters[widget.currentChapterIndex + 1];
              // Thay thế màn hình hiện tại bằng màn hình mới (chương sau)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ReaderScreen(
                    bookId: widget.bookId,
                    chapterId: nextChapter.id,
                    chapterTitle: nextChapter.title,
                    bookTitle: widget.bookTitle,
                    allChapters: widget.allChapters,
                    currentChapterIndex: widget.currentChapterIndex + 1,
                  ),
                ),
              );
            },
          )
        else
          Container(), // Để trống nếu không có chương sau
      ],
    );
  }
}
