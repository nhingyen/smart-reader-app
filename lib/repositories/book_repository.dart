import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/repositories/_mock_data.dart';

class BookRepository {
  final List<BookCategory> _categories = [
    BookCategory(id: "1", name: "Văn học", endpoint: "literature"),
    BookCategory(id: "2", name: "Lãng mạn", endpoint: "romance"),
    BookCategory(id: "3", name: "Thiếu nhi", endpoint: "children"),
    BookCategory(id: "4", name: "Khoa học", endpoint: "science"),
    BookCategory(id: "5", name: "Truyện ngắn", endpoint: "short_stories"),
    BookCategory(id: "6", name: "Trinh thám", endpoint: "mystery"),
  ];

  /// Giả lập lấy danh sách thể loại
  Future<List<BookCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 500)); // giả lập delay
    return _categories;
  }

  Future<List<Book>> fetchBooksByCategory(
    String endpoint, {
    int limit = 10,
  }) async {
    print('📚 REPOSITORY: Fetching books for endpoint: $endpoint');
    await Future.delayed(const Duration(milliseconds: 500));

    // 💡 Tối ưu hóa Tìm kiếm: Lọc từ danh sách mockBooks chung
    final filteredBooks = mockBooks.where((book) {
      // Giả định genres trong Model chứa endpoint
      return book.genres.contains(endpoint);
    }).toList();

    return filteredBooks.take(limit).toList();
  }

  // 💡 HÀM MỚI: Lấy chi tiết sách
  Future<Book> fetchBookDetails(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    try {
      // Tìm cuốn sách đầu tiên có ID khớp
      final book = mockBooks.firstWhere((b) => b.bookId == bookId);
      return book;
    } catch (e) {
      // Nếu không tìm thấy ID, ném lỗi để BLoC xử lý trạng thái Error
      throw Exception("Book not found with ID: $bookId");
    }
  }

  Future<List<Book>> fetchContinueReading() async {
    // Giả lập độ trễ khi tải dữ liệu
    await Future.delayed(const Duration(milliseconds: 700));

    // Lọc các sách có 'isAddedToLibrary' là true
    // và giới hạn số lượng để hiển thị trên Home Screen
    final continueReadingList = mockBooks.where((book) {
      // 💡 LOGIC: Sách đã được thêm vào thư viện và có thể coi là đang đọc dở
      return book.isAddedToLibrary == true;
    }).toList();

    // 💡 Tùy chọn: Giới hạn chỉ lấy 5 cuốn để hiển thị trong mục cuộn ngang
    return continueReadingList.take(5).toList();
  }
}
