import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/hospital.dart';
import 'screens/hospital_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: HospitalListScreen(),
    );
  }
}

class HospitalListScreen extends StatelessWidget {
  final List<Hospital> hospitals = [
    Hospital(
      name: "가디언동물의료센터",
      location: "서울 서초구 방배로 110 2층 201호",
      phone: "02-442-8287",
      website: "guardian-amc.com",
      status: "진료중",
      region: "서초구",
      imageUrl: "https://via.placeholder.com/600x400",
      description: "최고의 동물 의료 서비스를 제공합니다.",
      rating: 4.5,
      distance: 2.3,  // 병원까지의 거리 (예: km 단위)
      hours: "10:00 - 20:00",  // 운영 시간
      isOpen: true,  // 영업 중 여부
      openingHours: "10:00 AM - 8:00 PM",  // 상세 운영 시간
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("병원 목록")),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          final hospital = hospitals[index];
          return ListTile(
            title: Text(hospital.name),
            subtitle: Text(hospital.location),
            leading: Image.network(hospital.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HospitalDetailScreen(hospital: hospital),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
