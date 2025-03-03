import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:forlong/services/api_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../screens/main_screens.dart';
import '../screens/webview_login_screen.dart';

class SocialLoginService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static final Dio _dio = Dio();
  static const String _baseUrl = "http://3.34.157.88:8080";
  //static const String _baseUrl = "http://172.20.10.6:8080";

  /// ✅ **앱 실행 시 자동 로그인 체크**
  static Future<void> checkAutoLogin(BuildContext context) async {
    String? user_loginId = await _storage.read(key: 'loginId');

    if (user_loginId != null) {
      print("✅ 자동 로그인 성공! loginId 있음");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreens()),
      );
    }
  }

  /// ✅ **사용자가 로그인 버튼 클릭 시 실행**
  static Future<void> loginWithProvider(String provider, BuildContext context) async {
    final String loginUrl = "$_baseUrl/oauth2/authorization/$provider";

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewLoginScreen(loginUrl: loginUrl),
      ),
    );

    // ✅ 로그인 후 토큰 확인 및 저장
    await _fetchAndStoreTokens();
    await getLoginIdFromToken();

    String? loginId = await _storage.read(key:'loginId');
    if (loginId != null) {
      print("✅ 로그인 성공! 로그인아이디 저장됨: $loginId");
      final user = await ApiService.fetchUserFromServer(loginId);
      Provider.of<UserProvider>(context, listen: false).setUser(user!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreens()),
      );
    }
  }

  /// ✅ **쿠키에서 JWT 및 Refresh Token 가져와 저장**
  static Future<void> _fetchAndStoreTokens() async {
      List<Cookie> cookies = await CookieManager.instance().getCookies(url: WebUri(_baseUrl));
      for (var cookie in cookies) {
        if (cookie.name == "refresh") {
          await _storage.write(key: "refreshToken", value: cookie.value);
          print("✅ Refresh 토큰 저장됨: ${cookie.value}");
        }
      }
  }

  static Future<bool> refreshAccessToken() async {
    print("🔄 Refresh Token을 사용하여 Access Token 발급 시도...");

    String? refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      print("🚨 Refresh Token 없음! 자동 로그인 불가.");
      return false;
    }

    print("🔍 현재 저장된 Refresh Token: $refreshToken"); // ✅ 저장된 Refresh Token 출력

    try {
      var response = await _dio.post(
        "$_baseUrl/api/auth/access-token",
        options: Options(headers: {
          "Cookie": "refresh=$refreshToken", // ✅ Refresh Token을 Cookie로 전달
          "Accept": "application/json"
        }),
      );

      if (response.statusCode == 200 && response.data["data"]?["access_token"] != null) {
        String newAccessToken = response.data["data"]["access_token"];
        await _storage.write(key: 'accessToken', value: newAccessToken);
        print("✅ Access Token 발급 완료: $newAccessToken");
        return true;
      } else {
        print("🚨 Access Token 발급 실패: ${response.data}");
        return false;
      }
    } catch (e) {
      print("❌ Access Token 발급 요청 실패: $e");
      return false;
    }
  }

  // 유저의 loginId 추출후 저장
  static Future<void> getLoginIdFromToken() async {
    String? refreshToken = await _storage.read(key: 'refreshToken');

    if (refreshToken == null) return;

    Map<String, dynamic> decodedToken = Jwt.parseJwt(refreshToken); // JWT 디코딩
    String? loginId = decodedToken["loginId"]; // loginId 가져오기
    await _storage.write(key: "loginId", value: loginId);
  }
}
