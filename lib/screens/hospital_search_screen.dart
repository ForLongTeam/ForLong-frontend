import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:forlong/screens/reservation_screen.dart';
import '../models/hospital.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';


import 'hospital_detail_screen.dart';

class HospitalSearchScreen extends StatefulWidget {
  @override
  _HospitalSearchScreenState createState() => _HospitalSearchScreenState();
}

class _HospitalSearchScreenState extends State<HospitalSearchScreen> {
  late NaverMapController _mapController;
  bool isMapReady = false;
  String userInputext = '';

  List<Hospital> hospitalList = [
    Hospital(
      name: "서울동물병원",
      status: "진료중",
      region: "서울 강남구",
      location: "서울특별시 강남구 테헤란로 123",
      latitude: 37.499590,
      longitude: 127.027650,
      phone: "02-1234-5678",
      website: "http://seouldvm.com",
      imageUrl: "https://placehold.co/70",
      description: "서울 최고의 동물병원으로 다양한 진료 서비스를 제공합니다.",
      rating: 4.8,
      distance: 1.2,
      hours: "09:00 - 21:00",
      isOpen: true,
      openingHours: "09:00 AM - 9:00 PM",
    ),
    Hospital(
      name: "해피펫동물병원",
      status: "진료중",
      region: "서울 마포구",
      location: "서울특별시 마포구 양화로 45",
      latitude: 37.556300,
      longitude: 126.910010,
      phone: "02-2345-6789",
      website: "http://happypetclinic.co.kr",
      imageUrl: "https://via.placeholder.com/600x400",
      description: "반려동물 전문 의료기관으로 정밀 진단 및 수술 서비스를 제공합니다.",
      rating: 4.5,
      distance: 2.5,
      hours: "10:00 - 20:00",
      isOpen: true,
      openingHours: "10:00 AM - 8:00 PM",
    ),
    Hospital(
      name: "강남24시동물병원",
      status: "진료중",
      region: "서울 서초구",
      location: "서울특별시 서초구 서초대로 311",
      latitude: 37.491630,
      longitude: 127.007800,
      phone: "02-5678-1234",
      website: "http://gangnamvet.com",
      imageUrl: "https://via.placeholder.com/600x400",
      description: "24시간 운영하는 응급 의료 서비스 제공 동물 병원입니다.",
      rating: 4.7,
      distance: 0.8,
      hours: "24시간 운영",
      isOpen: true,
      openingHours: "24 Hours",
    ),
    Hospital(
      name: "푸른숲동물병원",
      status: "영업 종료",
      region: "서울 종로구",
      location: "서울특별시 종로구 인사동길 45",
      latitude: 37.572020,
      longitude: 126.987700,
      phone: "02-6789-1234",
      website: "http://greenforestvet.co.kr",
      imageUrl: "https://via.placeholder.com/600x400",
      description: "친환경적인 공간에서 동물들을 치료하는 병원입니다.",
      rating: 4.2,
      distance: 3.1,
      hours: "09:00 - 18:00",
      isOpen: false,
      openingHours: "9:00 AM - 6:00 PM",
    ),
    Hospital(
      name: "스타펫동물병원",
      status: "진료중",
      region: "서울 송파구",
      location: "서울특별시 송파구 올림픽로 88",
      latitude: 37.515040,
      longitude: 127.130100,
      phone: "02-7890-5678",
      website: "http://starpethospital.co.kr",
      imageUrl: "https://via.placeholder.com/600x400",
      description: "최신 의료 장비를 도입한 첨단 동물 병원입니다.",
      rating: 4.9,
      distance: 1.5,
      hours: "09:00 - 22:00",
      isOpen: true,
      openingHours: "9:00 AM - 10:00 PM",
    ),
    Hospital(
      name: "러브펫동물병원",
      status: "진료중",
      region: "서울 성동구",
      location: "서울특별시 성동구 왕십리로 222",
      latitude: 37.563600,
      longitude: 127.026600,
      phone: "02-3333-2222",
      website: "http://lovepethospital.co.kr",
      imageUrl: "assets/placeholder.png",
      description: "가족 같은 분위기의 친절한 동물 병원입니다.",
      rating: 4.6,
      distance: 2.8,
      hours: "10:00 - 20:00",
      isOpen: true,
      openingHours: "10:00 AM - 8:00 PM",
    ),
    Hospital(
      name: "스마일동물병원",
      status: "영업 종료",
      region: "서울 중구",
      location: "서울특별시 중구 명동로 45",
      latitude: 37.561000,
      longitude: 126.982700,
      phone: "02-8765-4321",
      website: "http://smilevet.com",
      imageUrl: "https://via.placeholder.com/600x400",
      description: "모든 반려동물에게 미소를 선사하는 병원입니다.",
      rating: 4.3,
      distance: 3.9,
      hours: "08:00 - 18:00",
      isOpen: false,
      openingHours: "8:00 AM - 6:00 PM",
    ),
  ];

  Future<void> deleteAllMarkerFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();

      for (var file in files) {
        if (file is File && file.path.endsWith('_marker.png')) {
          print("삭제 중: ${file.path}");
          await file.delete();
        }
      }

      print("모든 마커 파일 삭제 완료.");
    } catch (e) {
      print("파일 삭제 중 오류 발생: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    deleteAllMarkerFiles();
  }

  void _onMapReady(NaverMapController controller) {
    setState(() {
      _mapController = controller;
      isMapReady = true;
    });
    _addHospitalMarkers();
  }

  Future<String> _getOrCreateCustomMarker(Hospital hospital) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${hospital.name}_marker.png';

    if (File(filePath).existsSync()) {
      print("기존 마커 이미지 사용: $filePath");
      return filePath;
    }

    print("새로운 마커 이미지 생성 중...");

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()
      ..color = const Color(0xFF1BB881); // 초록색 배경 (#1BB881)

    // 크기 조정 비율
    const double scaleFactor = 3.0;

    // 아이콘 및 텍스트 설정 (크기 3배 확대)
    const double iconSize = 20 * scaleFactor; // 아이콘 크기
    const double paddingLeft = 4 * scaleFactor; // 아이콘을 왼쪽 끝에 가깝게 배치
    const double paddingBetween = 6 * scaleFactor; // 아이콘과 텍스트 간격 조정
    const double fontSize = 11 * scaleFactor; // 글씨 크기
    const double markerHeight = 28 * scaleFactor; // 마커 높이
    const double cornerRadius = 14 * scaleFactor; // 둥근 모서리 반경
    const double extraWidth = 5 * scaleFactor; // 추가 가로 크기

    // 병원 이름 길이에 따른 동적 크기 조정 (5 크기 추가 적용)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: hospital.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'Pretendard', // Pretendard 폰트 적용
        ),
      ),
    );

    textPainter.layout();
    final double textWidth = textPainter.width;
    final double markerWidth =
        textWidth + iconSize + paddingLeft + paddingBetween + extraWidth;

    // 둥근 사각형 배경 그리기 (더 넓어진 크기 적용)
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, markerWidth, markerHeight),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(rect, paint);

    // 왼쪽 아이콘 컨테이너 (왼쪽 끝에서 조금 떨어지도록 조정)
    final circlePaint = Paint()..color = Colors.white;
    final circleCenter = Offset(iconSize / 2 + paddingLeft, markerHeight / 2);
    canvas.drawCircle(circleCenter, iconSize / 2, circlePaint);

    // 위치 아이콘 추가 (아이콘을 원 안에 배치)
    final iconPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(Icons.place.codePoint),
        style: TextStyle(
          fontSize: 12 * scaleFactor,
          fontFamily: Icons.place.fontFamily,
          package: Icons.place.fontPackage,
          color: Color(0xFF1BB881),
        ),
      ),
    );

    iconPainter.layout();
    final double iconOffsetX = paddingLeft + (iconSize - iconPainter.width) / 2;
    final double iconOffsetY = (markerHeight - iconPainter.height) / 2;
    iconPainter.paint(canvas, Offset(iconOffsetX, iconOffsetY));

    // 병원 이름 텍스트 추가 (왼쪽으로 2만큼 이동)
    final double textOffsetX =
        iconSize + paddingLeft + paddingBetween - (2 * scaleFactor);
    final double textOffsetY = (markerHeight - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textOffsetX, textOffsetY));

    // 마커 하단 삼각형 핀 추가 (크기 3배 확대 적용)
    final path = Path();
    path.moveTo(markerWidth / 2 - (6 * scaleFactor), markerHeight);
    path.lineTo(markerWidth / 2 + (6 * scaleFactor), markerHeight);
    path.lineTo(markerWidth / 2, markerHeight + (8 * scaleFactor));
    path.close();

    final trianglePaint = Paint()..color = const Color(0xFF1BB881);
    canvas.drawPath(path, trianglePaint);

    // 이미지로 변환 및 저장
    final picture = recorder.endRecording();
    final img = await picture.toImage(
        markerWidth.toInt(), (markerHeight + (8 * scaleFactor)).toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();

    final file = File(filePath);
    await file.writeAsBytes(uint8List);

    if (!file.existsSync()) {
      throw Exception("마커 이미지 생성 실패: $filePath");
    }

    hospital.markerImagePath = filePath;
    return filePath;
  }

// 아이콘 로딩 함수
  Future<ui.Image> _loadAssetImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void _addHospitalMarkers() async {
    for (var hospital in hospitalList) {
      try {
        final markerPath = await _getOrCreateCustomMarker(hospital);

        if (File(markerPath).existsSync()) {
          final marker = NMarker(
            id: hospital.name,
            position: NLatLng(hospital.latitude, hospital.longitude),
            icon: NOverlayImage.fromFile(File(markerPath)), // File 객체로 변환
          );

          marker.setOnTapListener((overlay) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HospitalDetailScreen(hospital: hospital),
              ),
            );
          });

          _mapController.addOverlay(marker);
        } else {
          print("마커 파일이 존재하지 않습니다: $markerPath");
        }
      } catch (e) {
        print("마커 추가 중 오류 발생: $e");
      }
    }
  }

  void _showHospitalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: hospitalList.length,
          itemBuilder: (context, index) {
            final hospital = hospitalList[index];
            return GestureDetector(
              onTap: () {
                // 병원 상세 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HospitalDetailScreen(hospital: hospital),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 병원 이미지와 정보 (가로 배치)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  hospital.imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Text(
                                        '이미지 없음',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 30),
                              // 병원 정보 (세로 배치)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hospital.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Color(0xff1bb881), size: 18),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            hospital.location,
                                            style: const TextStyle(color: Color(0xff8EA0AC), fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          hospital.region.toString(),
                                          style: const TextStyle(fontSize: 14, color: Color(0xff666666)),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.star, color: Colors.orange, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          hospital.rating.toString(),
                                          style: const TextStyle(
                                              fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '${hospital.distance} km',
                                          style: const TextStyle(fontSize: 14, color: Color(0xff898d99)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 전화문의 및 예약하기 버튼 (가로 배치)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  launchUrl(Uri.parse('tel:${hospital.phone}'));
                                },
                                icon: const Icon(Icons.phone, size: 20, color: Color(0xff898d99),),
                                label: const Text('전화문의'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xfff7f7f7),
                                  foregroundColor: Color(0xff898d99),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  textStyle: const TextStyle(fontSize: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReservationScreen(hospital: hospital),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.calendar_today, size: 20, color: Colors.white,),
                                label: const Text('예약하기'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff1bb881),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.4950, 127.0290), // 초기 서울 위치
                zoom: 14,
              ),
              locationButtonEnable: true,
              indoorEnable: true,
            ),
            onMapReady: _onMapReady,
          ),
          Positioned(
            top: 70,
            left: 16,
            right: 16,
            child: TextField(
              decoration: InputDecoration(
                hintText: "지역이나 병원명을 검색해 보세요",
                suffixIcon: Container(
                  margin: const EdgeInsets.all(4), // 버튼 패딩 추가
                  decoration: BoxDecoration(
                    color: Color(0xFF1BB881), // 초록색 배경
                    borderRadius: BorderRadius.circular(50), // 둥근 버튼
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    // 흰색 돋보기 아이콘
                    onPressed: () {
                      _showHospitalModal();
                    },
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                setState(() {
                  userInputext = text;
                });//_showHospitalModal,
              }
            ),
          ),
        ],
      ),
    );
  }
}
