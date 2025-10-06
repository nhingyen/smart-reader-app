import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';

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
    await Future.delayed(const Duration(seconds: 1));

    switch (endpoint) {
      case 'literature':
        return [
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];
      case 'romance':
        return [
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];
      case 'children':
        return [
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];
      case 'science':
        return [
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];
      case 'short_stories':
        return [
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];
      case 'mystery':
        return [
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];
      default:
        return [];
    }
  }
}
