import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/main_screens.dart';

class WebViewLoginScreen extends StatefulWidget {
  final String loginUrl;

  const WebViewLoginScreen({Key? key, required this.loginUrl}) : super(key: key);

  @override
  _WebViewLoginScreenState createState() => _WebViewLoginScreenState();
}

class _WebViewLoginScreenState extends State<WebViewLoginScreen> {
  late InAppWebViewController webViewController;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("소셜 로그인")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.loginUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          print("📌 최종 URL: $url");

          // ✅ 모든 쿠키 출력
          List<Cookie> cookies = await CookieManager.instance().getCookies(url: WebUri("http://3.34.157.88:8080"));
          for (var cookie in cookies) {
            print("🍪 쿠키: ${cookie.name} = ${cookie.value}");
          }

          // ✅ JWT 토큰 확인
          String? refreshToken;
          for (var cookie in cookies) {
            if (cookie.name == "refresh") {
              refreshToken = cookie.value;
              print("✅ refresh 토큰 추출: $refreshToken");
              await _storage.write(key: "refreshToken", value: refreshToken);
              break;
            }
          }

          if (refreshToken != null) {
            print("✅ 로그인 성공! JWT 토큰 저장 완료.");

            //토큰 디코딩해서 유저로그인아이디 뽑아서 회원정보 조회 api를 이용해서 정보 받아서 저장하기

            if (mounted) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainScreens()),
              );
            }
          }
          else{
            print("🚨 로그인 실패: refresh 토큰을 가져오지 못함");
          }
        },
      ),
    );
  }
}
