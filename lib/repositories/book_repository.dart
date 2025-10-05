import 'package:smart_reader/models/book.dart';

class BookRepository {
  Future<List<Book>> getBooksByCategory(String endpoint) async {
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
