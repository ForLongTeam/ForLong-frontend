import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:forlong/screens/login_screen.dart';
import 'package:forlong/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:forlong/screens/main_screens.dart';
import '../provider/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    clearSecureStorage();
    _checkLoginStatus();
  }

  /// ✅ JWT 토큰 확인 후 자동 로그인 여부 결정
  Future<void> _checkLoginStatus() async {
    String? user_loginId = await _storage.read(key: 'loginId');
    if (user_loginId != null) {
      /// ✅ 로컬 저장된 유저 정보 불러오기
      final user = await ApiService.fetchUserFromServer(user_loginId);
      print("🔍 [DEBUG] 서버에서 가져온 유저 정보: $user");
      /// ✅ `UserProvider`에 유저 정보 업데이트
      Provider.of<UserProvider>(context, listen: false).setUser(user!);

      /// ✅ 메인 화면으로 이동
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreens()));
      return;
    }

    /// ✅ 로그인 화면으로 이동
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/splash_logo.png', width: 200), // ✅ 스플래시 로고
      ),
    );
  }

  Future<void> clearSecureStorage() async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll(); // ✅ 모든 보안 저장 데이터 삭제
  }
}
