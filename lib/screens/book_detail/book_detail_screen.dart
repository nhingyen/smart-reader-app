import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/chapter_info.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/book_detail/bloc/book_detail_bloc.dart';
import 'package:smart_reader/screens/book_detail/bloc/book_detail_event.dart';
import 'package:smart_reader/screens/book_detail/bloc/book_detail_state.dart';
import 'package:smart_reader/screens/reader/reader_sceen.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/buttons.dart';
// ... import các file BLoC và Repository của bạn

class BookDetailScreen extends StatelessWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    // 1. Khởi tạo BLoC và tải dữ liệu ngay lập tức
    return BlocProvider(
      create: (context) =>
          BookDetailBloc(repository: BookRepository())
            ..add(LoadBookDetailEvent(bookId: bookId)),
      child: Scaffold(
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoading || state is BookDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookDetailLoaded) {
              final book = state.book;
              return _buildLoadedContent(context, book);
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
  Widget _buildLoadedContent(BuildContext context, Book book) {
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
            const Center(child: Text("Chức năng Reviews")),
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
    final bool isAdded = book.isAddedToLibrary;

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
                      currentChapterIndex: 0, // First chapter has index 0
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
            ListButtons(
              isAdded ? "Đã thêm vào" : "Thêm thư viện",
              isAdded ? Icons.check : Icons.add,
              () {},
            ),
            const SizedBox(width: 10),
            ListButtons("Đánh giá", Icons.edit, () {}),
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
                      style: TextStyle(fontSize: 13),
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
                  "${book.chapterCount.toInt()} Chương",
                  style: TextStyle(fontSize: 13),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
