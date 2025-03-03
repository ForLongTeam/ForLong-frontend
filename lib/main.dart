import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
<<<<<<< Updated upstream
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:forlong/screens/hospital_search_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:forlong/dto_favorite_manager.dart';
import 'package:forlong/provider/user_provider.dart';
import 'package:forlong/screens/main_screens.dart';
import 'package:forlong/screens/splash_screen.dart';
import 'package:forlong/services/api_service.dart';
import 'package:forlong/services/local_storage_service.dart';
import 'package:forlong/services/location_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'favorite_manager.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'models/user_model.dart';
>>>>>>> Stashed changes

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 네이버 지도 SDK 초기화
  NaverMapSdk.instance.initialize(
    clientId: '29brsoczm8', // 네이버 클라이언트 ID 입력
    onAuthFailed: (exception) {
      print('네이버 지도 인증 실패: $exception');
    },
  );

  // ✅ Hive 초기화
  await LocalStorageService.init();

  // ✅ 기존 유저 데이터 삭제 (테스트용)
  await LocalStorageService.clearLocalUser();
  LocalStorageService.printUserBoxContents();

  // ✅ 찜 기능 매니저 초기화
  await FavoriteManager.init();

  // ✅ 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko_KR', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // ✅ UserProvider 추가
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    //FavoriteManager.init(onUpdate: _updateFavorites);
    DtoFavoriteManager.init(onUpdate:  _updateFavorites);// ✅ UI 업데이트 콜백 추가
  }

  void _updateFavorites() {
    setState(() {}); // ✅ UI 즉시 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko', 'KR'),
      // ✅ 기본 한국어 설정
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
        Locale('en', 'US'), // 영어
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
<<<<<<< Updated upstream
      home: HospitalSearchScreen(),
=======
      home: SplashScreen(),
>>>>>>> Stashed changes
    );
  }
}
