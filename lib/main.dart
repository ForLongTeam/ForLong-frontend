import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:forlong/screens/hospital_search_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
    clientId: '29brsoczm8',  // 여기에 네이버 클라이언트 ID를 입력하세요.
    onAuthFailed: (exception) {
      print('네이버 지도 인증 실패: $exception');
    },
  );

  await initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko', 'KR'),  // 한국어 설정
      supportedLocales: const [
        Locale('ko', 'KR'),  // 한국어 지원
        Locale('en', 'US'),  // 영어도 함께 지원 가능
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HospitalSearchScreen(),
    );
  }
}