import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/chapter_info.dart';
import 'package:smart_reader/models/reivew.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/repositories/user_repository.dart';
import 'package:smart_reader/screens/book_detail/bloc/book_detail_bloc.dart';
import 'package:smart_reader/screens/book_detail/bloc/book_detail_event.dart';
import 'package:smart_reader/screens/book_detail/bloc/book_detail_state.dart';
import 'package:smart_reader/screens/home/bloc/home_bloc.dart';
import 'package:smart_reader/screens/home/bloc/home_event.dart';
import 'package:smart_reader/screens/reader/reader_screen.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/buttons.dart';
// ... import các file BLoC và Repository của bạn

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});
  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isAdded = false; // Trạng thái nút bấm
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  // Kiểm tra xem sách đã có trong thư viện chưa để hiện đúng màu nút
  void _checkStatus() async {
    if (user != null) {
      final status = await context.read<UserRepository>().checkIsAdded(
            user!.uid,
            widget.bookId,
          );
      setState(() {
        isAdded = status;
      });
    }
  }

  // Hàm xử lý khi bấm nút
  void _onToggleLibrary() async {
    if (user == null) {
      // Show dialog bắt đăng nhập
      return;
    }

    // 1. Gọi API
    final newStatus = await context.read<UserRepository>().toggleLibrary(
          user!.uid,
          widget.bookId,
        );

    // 2. Cập nhật UI nút bấm
    setState(() {
      isAdded = newStatus;
    });

    // 3. Quan trọng: Reload lại dữ liệu trang Home để danh sách cập nhật
    if (context.mounted) {
      context.read<HomeBloc>().add(LoadHomeDataEvent(userId: user!.uid));
    }

    // 4. Thông báo nhỏ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus ? "Đã thêm vào thư viện" : "Đã xóa khỏi thư viện",
        ),
      ),
    );
  }

  // --- HÀM MỞ FORM BÌNH LUẬN (MỚI) ---
  // Trong class _BookDetailScreenState

  void _showReviewForm(BuildContext context, String bookId) {
    // 1. Lấy instance của Bloc đang chạy TỪ TRONG SCOPE CỦA BOOKDETAILSCREEN
    final bookDetailBloc = context.read<BookDetailBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (modalContext) {
        // Dùng modalContext cho Widget con

        // 2. Bọc Form nhập liệu bằng BlocProvider.value
        return BlocProvider.value(
          value: bookDetailBloc, // 🎯 Truyền instance Bloc đã lấy vào Route mới
          child: ReviewInputForm(bookId: bookId),
        );
      },
    ).then((_) {
      // Tùy chọn: Reload lại dữ liệu trang chi tiết khi modal đóng
      if (context.mounted) {
        // Reload để cập nhật list reviews và điểm
        bookDetailBloc.add(LoadBookDetailEvent(bookId: widget.bookId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Khởi tạo BLoC và tải dữ liệu ngay lập tức
    return BlocProvider(
      create: (context) => BookDetailBloc(repository: BookRepository())
        ..add(LoadBookDetailEvent(bookId: widget.bookId)),
      child: Scaffold(
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoading || state is BookDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookDetailLoaded) {
              final book = state.book;
              final reviews = state.reviews;
              return _buildLoadedContent(context, book, reviews);
            }

            if (state is BookDetailError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text("Đang tải chi tiết sách..."));
          },
        ),
      ),
    );
  }

  // Phương thức tách riêng để xây dựng UI sau khi tải dữ liệu thành công
  Widget _buildLoadedContent(
      BuildContext context, Book book, List<Review> reviews) {
    // Sử dụng DefaultTabController để quản lý 3 tabs: About, Chapters, Reviews
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                // Đặt SafeArea xung quanh CustomHeaderIcons
                SafeArea(
                  bottom: false, // Không áp dụng padding dưới
                  child: _buildCustomHeaderIcons(context, book.title),
                ),
              ]),
            ),
            SliverAppBar(
              toolbarHeight: 0,
              pinned: false,
              expandedHeight: 320.0, // Chiều cao tối đa của header

              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Padding(
                  padding: const EdgeInsets.only(top: 3, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildCustomHeaderIcons(context, book.title),
                      _buildBookInfo(book), // Chứa ảnh và chi tiết sách
                      const SizedBox(height: 20),
                      _buildActionButtons(context, book),
                    ],
                  ),
                ),
              ),

              // TabBar cố định
              bottom: const TabBar(
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textDark,
                tabs: [
                  Tab(text: "Tóm tắt"),
                  Tab(text: "Chương"),
                  Tab(text: "Đánh giá"),
                ],
              ),
            ),
          ];
        },
        // Nội dung của Tab Bar View
        body: TabBarView(
          children: [
            BookSynopsisTab(book: book),
            BookChaptersTab(book: book, chapters: book.chapters),
            BookReviewsTab(bookId: book.bookId, reviews: reviews),
          ],
        ),
      ),
    );
  }

  // Trong class BookDetailScreen (Thêm vào cùng nơi với các hàm _build...)

  Widget _buildCustomHeaderIcons(BuildContext context, String title) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Trong BookDetailScreen.dart (Hàm _buildActionButtons)

  Widget _buildActionButtons(BuildContext context, Book book) {
    // Lấy trạng thái của nút Add to Library
    // final bool isAdded = book.isAddedToLibrary;

    return Column(
      children: [
        // Hàng 1: Listen Now (Chính) và Read Now (Phụ)
        Row(
          children: [
            // 1. Listen Now (Nút chính)
            ListButtons(
              "Nghe ngay",
              Icons.play_arrow,
              () {},
              isPrimary: true, //nút chính
            ),
            const SizedBox(width: 10),
            ListButtons("Đọc ngay", Icons.menu_book, () {
              print('đang vào chương 1 đọc');
              //kiem tra xem danh sach co chuong nào ko
              if (book.chapters.isNotEmpty) {
                final firstChapter = book.chapters[0];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReaderScreen(
                      chapterId: firstChapter.id,
                      chapterTitle: firstChapter.title,
                      bookTitle: book.title,

                      allChapters: book.chapters,
                      currentChapterIndex: 0,
                      bookId: book.bookId, // First chapter has index 0
                    ),
                  ),
                );
              } else {
                // Tùy chọn: Hiển thị thông báo nếu không có chương
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Sách này hiện chưa có chương nào."),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }),
          ],
        ),

        const SizedBox(height: 10),

        // Hàng 2:
        Row(
          children: [
            // Thay thế ListButtons cũ bằng Expanded + OutlinedButton để giống thiết kế
            Expanded(
              child: SizedBox(
                height: 42, // Chiều cao cho bằng nút bên cạnh
                child: OutlinedButton.icon(
                  // 3. GẮN HÀM XỬ LÝ VÀO ĐÂY
                  onPressed: _onToggleLibrary,

                  // Icon thay đổi theo trạng thái
                  icon: Icon(
                    isAdded ? Icons.check : Icons.add,
                    color:
                        isAdded ? AppColors.primary : const Color(0xFF28C7A0),
                  ),

                  // Chữ thay đổi theo trạng thái
                  label: Text(
                    isAdded ? "Đã thêm" : "Thêm thư viện",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isAdded ? AppColors.primary : AppColors.primary,
                    ),
                  ),

                  // Style viền
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isAdded ? AppColors.primary : AppColors.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton.icon(
                  onPressed: () => _showReviewForm(
                      context, book.bookId), // 🎯 GẮN HÀM VÀO ĐÂY
                  icon: Icon(Icons.edit, color: Colors.grey[700]),
                  label: Text("Bình luận",
                      style: TextStyle(color: Colors.grey[700])),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Tách riêng _buildBookInfo để chứa nội dung Row cũ của bạn
  Widget _buildBookInfo(Book book) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(book.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  book.author.authorName,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      book.rating.toString(),
                      style: TextStyle(fontSize: 13, color: AppColors.textDark),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.star,
                      size: 15,
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
                Text(
                  "${book.chapters.length} Chương",
                  style: TextStyle(fontSize: 13, color: AppColors.textDark),
                ),
                // Thêm rating và thống kê ở đây
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Cần tạo các file widget này để chứa nội dung từng Tab
class BookSynopsisTab extends StatelessWidget {
  final Book book;
  const BookSynopsisTab({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tóm tắt nội dung sách",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(book.description, style: TextStyle(color: Colors.black54)),
          // ... Thêm các Tags/Genres tại đây
        ],
      ),
    );
  }
}

class BookChaptersTab extends StatelessWidget {
  final Book book;
  final List<ChapterInfo> chapters;
  const BookChaptersTab({
    super.key,
    required this.book,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return ListTile(
          title: Text(chapter.title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReaderScreen(
                  bookId: book.bookId,
                  // 1. Thông tin chương hiện tại
                  chapterId: chapter.id,
                  chapterTitle: chapter.title,
                  bookTitle: book.title,

                  // 2. Thông tin để lật trang
                  allChapters: book.chapters,
                  currentChapterIndex: index,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ===========================================
// WIDGET CON: TAB VÀ FORM (THÊM VÀO CUỐI FILE)
// ===========================================

// A. BookReviewsTab (Hiển thị danh sách)
class BookReviewsTab extends StatelessWidget {
  final String bookId;
  final List<Review> reviews;

  const BookReviewsTab(
      {super.key, required this.bookId, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // NÚT MỞ FORM BÌNH LUẬN
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton.icon(
            onPressed: () {
              // Gọi hàm mở form từ State cha
              (context.findAncestorStateOfType<_BookDetailScreenState>()
                      as _BookDetailScreenState)
                  ._showReviewForm(context, bookId);
            },
            icon: const Icon(Icons.comment, color: Colors.white),
            label: const Text("Viết bình luận của bạn",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: AppColors.primary),
          ),
        ),

        // DANH SÁCH BÌNH LUẬN
        Expanded(
          child: reviews.isEmpty
              ? const Center(child: Text("Chưa có bình luận nào."))
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ListTile(
                      // 1. AVATAR
                      leading: CircleAvatar(
                        // backgroundImage: review.userPhoto.isNotEmpty
                        //     ? NetworkImage(review.userPhoto) as ImageProvider
                        //     : null,
                        child: review.userPhoto.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),

                      // 2. TÊN USER
                      title: Text(
                        'Người ẩn danh', // Hiển thị tên
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(review.comment),
                      trailing:
                          Text(review.createdAt.toString().substring(0, 10)),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// B. ReviewInputForm (Form Nhập liệu - Dạng BottomSheet)
class ReviewInputForm extends StatefulWidget {
  final String bookId;

  const ReviewInputForm({super.key, required this.bookId});

  @override
  State<ReviewInputForm> createState() => _ReviewInputFormState();
}

class _ReviewInputFormState extends State<ReviewInputForm> {
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() async {
    final user = FirebaseAuth.instance.currentUser;
    final commentText = _commentController.text.trim();

    if (user == null || _isSubmitting || commentText.isEmpty) {
      if (commentText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vui lòng nhập nội dung bình luận.")));
      }
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repo = context.read<BookRepository>();

      // 1. Gửi bình luận (Comment Only)
      await repo.submitReview(
        userId: user.uid,
        bookId: widget.bookId,
        comment: commentText,
      );

      // 2. Thông báo thành công và reload
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bình luận của bạn đã được gửi!")));

        // 🎯 RELOAD BLOC: Tải lại chi tiết sách để list reviews được cập nhật
        context
            .read<BookDetailBloc>()
            .add(LoadBookDetailEvent(bookId: widget.bookId));

        Navigator.pop(context); // Đóng BottomSheet
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi: Không thể gửi bình luận: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 16,
          right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Viết bình luận",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Ô nhập comment
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Cảm nhận của bạn về cuốn sách...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitComment,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.primary),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text("Gửi bình luận",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
