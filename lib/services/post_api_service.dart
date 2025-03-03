import 'dart:convert';
import 'package:http/http.dart' as http;

class PostApiService {
  final String baseUrl = "http://3.34.157.88:8080"; // API 서버 주소

  Future<Map<String, dynamic>> createPost({
    required String loginId,
    required String title,
    required String content,
  }) async {
    final Uri url = Uri.parse('$baseUrl/api/posts/');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "loginId": loginId,
      "title": title,
      "content": content,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return {"status": "success", "message": "게시물이 등록되었습니다."};
      } else if (response.statusCode == 400) {
        return {"status": "error", "message": "해당 회원이 존재하지 않습니다."};
      } else {
        return {"status": "error", "message": "서버 오류가 발생했습니다."};
      }
    } catch (e) {
      return {"status": "error", "message": "네트워크 오류가 발생했습니다."};
    }
  }
}
