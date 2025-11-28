import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smart_reader/models/chapter_info.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/repositories/user_repository.dart';
import 'package:smart_reader/screens/reader/bloc/reader_bloc.dart';
import 'package:smart_reader/screens/reader/bloc/reader_state.dart';

// === 1. WIDGET VỎ (WRAPPER) - NHIỆM VỤ KHỞI TẠO BLOC ===
class ReaderScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Khởi tạo BlocProvider ở đây
    return BlocProvider(
      create: (context) => ReaderBloc(repository: BookRepository())
        ..add(LoadChapterContentEvent(chapterId: chapterId)),
      // Gọi Widget con chứa giao diện
      child: ReaderView(
        bookId: bookId,
        chapterId: chapterId,
        bookTitle: bookTitle,
        chapterTitle: chapterTitle,
        allChapters: allChapters,
        currentChapterIndex: currentChapterIndex,
      ),
    );
  }
}

// === 2. WIDGET GIAO DIỆN & LOGIC (VIEW) ===
class ReaderView extends StatefulWidget {
  final String bookId;
  final String chapterId;
  final String bookTitle;
  final String chapterTitle;
  final List<ChapterInfo> allChapters;
  final int currentChapterIndex;

  const ReaderView({
    super.key,
    required this.bookId,
    required this.chapterId,
    required this.bookTitle,
    required this.chapterTitle,
    required this.allChapters,
    required this.currentChapterIndex,
  });

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {
  DateTime? _startTime;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoadingAudio = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- LOGIC TTS (TEXT TO SPEECH) ---
  String _stripHtml(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String text = htmlString.replaceAll(exp, ' ');
    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  void _handleListenChapter() async {
    final state = context.read<ReaderBloc>().state; // Context này đã an toàn
    if (state is! ReaderLoaded) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isLoadingAudio = true);

    try {
      String cleanText = _stripHtml(state.chapter.content);
      if (cleanText.length > 4000) {
        cleanText = cleanText.substring(0, 4000) + "...";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chỉ đọc 4000 ký tự đầu.")),
        );
      }

      final repo = context.read<BookRepository>();
      final base64String = await repo.getAudioFromText(cleanText);

      if (base64String != null) {
        final bytes = base64Decode(base64String);
        await _audioPlayer.play(BytesSource(bytes));
        setState(() => _isPlaying = true);

        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) setState(() => _isPlaying = false);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi tải âm thanh")),
        );
      }
    } catch (e) {
      print("Lỗi TTS: $e");
    } finally {
      if (mounted) setState(() => _isLoadingAudio = false);
    }
  }

  // --- LOGIC THỐNG KÊ (STATS) ---
  Future<void> _updateStats() async {
    if (_startTime == null) return;
    final minutes = DateTime.now().difference(_startTime!).inMinutes;

    // Tắt kiểm tra < 1 phút để test cho dễ, khi release thì mở lại
    // if (minutes < 1) return;

    int currentIndex = widget.currentChapterIndex;
    int totalChapters = widget.allChapters.length;
    final isLastChapter = currentIndex == (totalChapters - 1);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await context.read<UserRepository>().updateReadingStats(
            userId: user.uid,
            bookId: widget.bookId,
            minutesRead: minutes,
            isBookFinished: isLastChapter,
          );
    }
  }

  void _saveProgress() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<UserRepository>().saveReadingProgress(
            userId: user.uid,
            bookId: widget.bookId,
            chapterId: widget.chapterId,
          );
    }
  }

  Future<void> _onExit() async {
    await _updateStats();
    _saveProgress();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // KHÔNG bọc BlocProvider ở đây nữa
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop) {
          _saveProgress();
          await _updateStats();
        }
      },
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: _onExit, // Gọi hàm thoát chuẩn
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bookTitle,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            "Chương ${widget.currentChapterIndex + 1}/${widget.allChapters.length}",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
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
                      color: Colors.black87),
                ),
                const SizedBox(height: 16),
                HtmlWidget(
                  state.chapter.content,
                  textStyle: const TextStyle(
                      fontSize: 16, height: 1.6, color: Colors.black87),
                ),
                _buildChapterNavigation(context),
              ],
            ),
          );
        }
        if (state is ReaderError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("Đang tải..."));
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
          Divider(height: 1.0, thickness: 1.0, color: Colors.grey[300]),
          const SizedBox(height: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // --- NÚT NGHE SÁCH (Đã sửa) ---
                  _buildCustomNavItem(
                    icon: _isLoadingAudio
                        ? Icons.hourglass_empty
                        : (_isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled),
                    label: _isLoadingAudio
                        ? "Đang tải..."
                        : (_isPlaying ? "Dừng lại" : "Nghe sách"),
                    iconColor:
                        _isPlaying ? Colors.red : const Color(0xFF28C7A0),
                    bgColor: _isPlaying
                        ? const Color(0xFFFFF0F0)
                        : const Color(0xFFE0F8F3),
                    onTap: _isLoadingAudio ? () {} : _handleListenChapter,
                  ),
                  // -----------------------------
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildChapterNavigation(BuildContext context) {
    final bool hasPrevious = widget.currentChapterIndex > 0;
    final bool hasNext =
        widget.currentChapterIndex < widget.allChapters.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasPrevious)
          TextButton(
            onPressed: () {
              final prev = widget.allChapters[widget.currentChapterIndex - 1];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ReaderScreen(
                    bookId: widget.bookId,
                    chapterId: prev.id,
                    bookTitle: widget.bookTitle,
                    chapterTitle: prev.title,
                    allChapters: widget.allChapters,
                    currentChapterIndex: widget.currentChapterIndex - 1,
                  ),
                ),
              );
            },
            child: const Row(children: [
              Icon(Icons.arrow_back_ios, size: 13, color: Colors.black),
              Text("Chương trước", style: TextStyle(color: Colors.black))
            ]),
          )
        else
          Container(),
        if (hasNext)
          TextButton(
            onPressed: () {
              final next = widget.allChapters[widget.currentChapterIndex + 1];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ReaderScreen(
                    bookId: widget.bookId,
                    chapterId: next.id,
                    bookTitle: widget.bookTitle,
                    chapterTitle: next.title,
                    allChapters: widget.allChapters,
                    currentChapterIndex: widget.currentChapterIndex + 1,
                  ),
                ),
              );
            },
            child: const Row(children: [
              Text("Chương sau", style: TextStyle(color: Colors.black)),
              Icon(Icons.arrow_forward_ios, size: 13, color: Colors.black)
            ]),
          )
        else
          Container(),
      ],
    );
  }
}
