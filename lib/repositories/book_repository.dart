import 'dart:convert';

import 'package:smart_reader/models/author.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/models/chapter_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BookRepository {
  // Sửa thành static GETTER
  static String get _baseUrl {
    final url = dotenv.env['baseURL'];
    if (url == null) {
      // Báo lỗi rõ ràng hơn nếu .env bị thiếu
      throw Exception("Lỗi: Không tìm thấy 'baseURL' trong file .env");
    }
    return url;
  }
  // 3. Dùng cho Điện thoại thật (CẮM CÁP hoặc CÙNG WIFI):
  // (Thay 192.168.1.5 bằng IP Wifi của MÁY TÍNH bạn)
  // static const String _baseUrl = "http://192.168.1.5:5001";

  //Helper function để xử lý response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Lỗi khi gọi API (Status code: ${response.statusCode})');
    }
  }

  // lấy tat ca thể loại
  Future<List<BookCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/categories'));
    final data = _handleResponse(response) as List;
    return data.map((json) => BookCategory.fromJson(json)).toList();
  }

  // Lấy sách theo thể loại
  Future<List<Book>> fetchBooksByCategory(
    String endpoint, {
    int limit = 10,
  }) async {
    print('REPOSITORY: Fetching books for endpoint: $endpoint');
    await Future.delayed(const Duration(milliseconds: 500));

    final response = await http.get(
      Uri.parse('$_baseUrl/api/books?genre=$endpoint&limit=$limit'),
    );
    final data = _handleResponse(response) as List;

    return data.map((json) => Book.fromJson(json)).toList();
  }

  //Lấy chi tiết sách
  Future<Book> fetchBookDetails(String bookId) async {
    print('REPOSITORY: Fetching book details for: $bookId');
    final response = await http.get(Uri.parse('$_baseUrl/api/books/$bookId'));
    final data = _handleResponse(response);
    return Book.fromJson(data);
  }

  // Lấy nội dung chương
  Future<ChapterDetail> fetchChapterContent(String chapterId) async {
    print('📚 REPOSITORY: Fetching chapter content for: $chapterId');
    final response = await http.get(
      Uri.parse('$_baseUrl/api/chapters/$chapterId'),
    );
    final data = _handleResponse(response);
    return ChapterDetail.fromJson(data);
  }

  //Lấy dữ liệu tổng hợp cho Home
  Future<Map<String, dynamic>> fetchHomeData() async {
    print('REPOSITORY: Fetching all data for Home Screen');
    final response = await http.get(Uri.parse('$_baseUrl/api/home'));
    final data = _handleResponse(response);

    // Parse dữ liệu từ API /api/home
    final categories = (data['categories'] as List)
        .map((json) => BookCategory.fromJson(json))
        .toList();

    final authors = (data['authors'] as List)
        .map((json) => Author.fromJson(json))
        .toList();

    final newBooks = (data['newBooks'] as List)
        .map((json) => Book.fromJson(json))
        .toList();

    final specialBooks = (data['specialBooks'] as List)
        .map((json) => Book.fromJson(json))
        .toList();

    return {
      'categories': categories,
      'authors': authors,
      'newBooks': newBooks,
      'specialBooks': specialBooks,
      'continueReading': <Book>[],
    };
  }

  //Lấy chi tiết tác giả
  Future<Map<String, dynamic>> fetchAuthorDetails(String authorId) async {
    print('REPOSITORY: Fetching author details for: $authorId');
    final response = await http.get(
      Uri.parse('$_baseUrl/api/authors/$authorId'),
    );
    print("RESPONSE RAW: ${response.body}");
    final data = _handleResponse(response);
    // 1️⃣ Parse author
    final author = Author.fromJson(data['author']);

    // 2️⃣ Parse books
    List<Book> books = [];
    if (data['books'] != null) {
      books = (data['books'] as List)
          .map((item) => Book.fromJson(item))
          .toList();
    }

    return {'author': author, 'books': books};
  }
}
