import 'package:flutter/material.dart';
import '../services/social_login_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// ✅ 배경 이미지
          Positioned.fill(
            child: Image.asset('assets/images/login_bg.png', fit: BoxFit.cover),
          ),

          /// ✅ 로고 및 소셜 로그인 버튼
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// ✅ 소셜 로그인 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialLoginButton('assets/icons/kakao.png', 'kakao', context),
                  _socialLoginButton('assets/icons/naver.png', 'naver', context),
                  _socialLoginButton('assets/icons/google.png', 'google', context),
                  _socialLoginButton('assets/icons/apple.png', 'apple', context),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ 소셜 로그인 버튼 위젯
  Widget _socialLoginButton(String asset, String provider, BuildContext context) {
    return GestureDetector(
      onTap: () => SocialLoginService.loginWithProvider(provider, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: 60, // ✅ 버튼 크기 통일
          height: 60, // ✅ 버튼 크기 통일
          child: Image.asset(asset, fit: BoxFit.contain), // ✅ 크기 자동 조정
        ),
      ),
    );
  }
}
