import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/server_post.dart'; // ✅ 서버에서 불러오는 Post 모델 사용

class ContentService {
  /// ✅ **홈 화면의 콘텐츠 데이터 불러오기 (서버 Post 모델 사용)**
  static Future<Map<String, List<ServerPost>>> loadHomeContent() async {
    try {
      // ✅ assets 폴더에서 JSON 파일 불러오기
      String jsonString = await rootBundle.loadString('assets/test_data.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);

      // ✅ JSON 데이터를 ServerPost 객체 리스트로 변환
      List<ServerPost> recentVetReplies = (jsonData['recentVetReplies'] as List)
          .map((data) => ServerPost.fromJson(data))
          .toList();

      List<ServerPost> hotIssues = (jsonData['hotIssues'] as List)
          .map((data) => ServerPost.fromJson(data))
          .toList();

      print("✅ 로컬 JSON 데이터 로드 성공!"); // 디버깅용 로그

      return {
        'recentVetReplies': recentVetReplies,
        'hotIssues': hotIssues,
      };
    } catch (e) {
      print("🚨 콘텐츠 데이터 로드 실패: $e");
      return {
        'recentVetReplies': [],
        'hotIssues': [],
      };
    }
  }
}
