import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_reader/models/reading_progess.dart';

class UserRepository {
  // Sửa thành static GETTER
  static String get _baseUrl {
    final url = dotenv.env['baseURL'];
    if (url == null) {
      // Báo lỗi rõ ràng hơn nếu .env bị thiếu
      throw Exception("Lỗi: Không tìm thấy 'baseURL' trong file .env");
    }
    return url;
  }

  Future<List<ReadingProgress>> fetchContinueReading(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/progress?userId=$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        // Map từng phần tử JSON sang Model ReadingProgress
        return data.map((json) => ReadingProgress.fromJson(json)).toList();
      } else {
        print("Lỗi API: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi fetchContinueReading: $e");
      return [];
    }
  }

  Future<void> saveReadingProgress({
    required String userId,
    required String bookId,
    required String chapterId,
  }) async {
    final url = Uri.parse('$_baseUrl/api/progress'); // API POST

    try {
      print('USER_REPO: Đang lưu tiến độ -> $url');
      print('Data: userId=$userId, bookId=$bookId, chap=$chapterId');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "bookId": bookId,
          "chapterId": chapterId,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Lưu tiến độ thành công!");
      } else {
        print("❌ Lỗi lưu tiến độ: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi kết nối khi lưu tiến độ: $e");
    }
  }
}
