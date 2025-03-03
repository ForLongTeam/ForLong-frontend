import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
<<<<<<< Updated upstream:lib/screens/hospital_search_screen.dart
import 'package:forlong/screens/reservation_screen.dart';
import '../models/hospital.dart';
import 'dart:ui' as ui;
=======
import 'package:forlong/services/hospital_service.dart';
import 'package:forlong/services/marker_service.dart';
import '../../dto_favorite_manager.dart';
import '../../favorite_manager.dart';
import '../../models/hospital.dart';
>>>>>>> Stashed changes:lib/screens/hospital/hospital_search_screen.dart
import 'dart:io';
import '../../models/hospitaldto.dart';
import '../../widgets/custom_widgets.dart';
import 'hospitaldto_detail_screen.dart';

class HospitalSearchScreen extends StatefulWidget {
  @override
  _HospitalSearchScreenState createState() => _HospitalSearchScreenState();
}

class _HospitalSearchScreenState extends State<HospitalSearchScreen> {
  late NaverMapController _mapController;
  bool isMapReady = false;
  String userInputext = '';
  List<Hospital> hospitalList = [];
  List<HospitalDto> hospitals = [];

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  void _onMapReady(NaverMapController controller) {
    setState(() {
      _mapController = controller;
      isMapReady = true;
    });
    _addHospitalMarkers();
  }

  // ✅ 병원 데이터를 가져와 UI를 업데이트하는 함수
  Future<void> _loadHospitals() async {
    try {
      //List<Hospital> hospitals = await ApiService.fetchHospitals(); // ✅ API 호출
      List<Hospital> hospitals = await HospitalService.fetchHospitalsFromLocal(); // ✅ API 호출

      setState(() {
        hospitalList = hospitals; // ✅ 데이터 수신 후 UI 업데이트
      });
    } catch (e) {
      print("🚨 병원 데이터 로딩 실패: $e");
    }
  }

  void _addHospitalMarkers() async {
    for (var hospital in hospitals) {
      try {
        String markerPath = await MarkerService.getOrCreatedtoCustomMarker(hospital);

        // 마커 이미지가 URL이면 다운로드 후 사용
        if (markerPath.startsWith('http')) {
          markerPath = await MarkerService.downloadAndSaveImage(markerPath, hospital.hospitalName);
        }

        final marker = NMarker(
          id: hospital.hospitalName,
          position: NLatLng(hospital.address.latitude as double, hospital.address.longitude as double),
          icon: NOverlayImage.fromFile(File(markerPath)), // 파일 경로 사용
        );

        marker.setOnTapListener((overlay) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HospitaldtoDetailScreen(hospital: hospital),
            ),
          );
        });

        _mapController.addOverlay(marker);
      } catch (e) {
        print("🚨 마커 추가 중 오류 발생: $e");
      }
    }
  }

  void _searchHospitalsAndShowModal() async {
    if (userInputext.isEmpty) return; // 입력값이 없으면 실행 안 함

    try {
      List<HospitalDto> results = await HospitalService.fetchHospitalsFromApi(userInputext);
      setState(() {
        hospitals = results;
      });

      if (hospitals.isNotEmpty) {
        _showHospitalModal(); // ✅ 검색 결과가 있으면 모달 표시
      } else {
        // 검색 결과가 없을 경우 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("검색 결과가 없습니다.")),
        );
      }
    } catch (e) {
      print("🚨 병원 검색 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("검색 중 오류가 발생했습니다.")),
      );
    }
  }


  /// ✅ 검색 결과를 모달로 표시
  void _showHospitalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder( // ✅ 상태 갱신을 위한 StatefulBuilder 사용
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = hospitals[index];
                  return CustomWidgets.buildHospitalDTOCard(
                    context: context,
                    hospital: hospital,
                    isFavorite: DtoFavoriteManager.isFavoriteHospital(hospital), // ✅ 찜 여부 체크
                    onFavoriteToggle: () {
                      DtoFavoriteManager.toggleFavoriteHospital(hospital);
                      setState(() {}); // ✅ UI 갱신
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  /*void _showHospitalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder( // ✅ 상태 갱신을 위한 StatefulBuilder 사용
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: hospitalList.length,
                itemBuilder: (context, index) {
                  final hospital = hospitalList[index];
                  return CustomWidgets.buildHospitalCard(
                    context: context,
                    hospital: hospital,
                    isFavorite: FavoriteManager.isFavoriteHospital(hospital), // ✅ 찜 여부 체크
                    onFavoriteToggle: () {
                      FavoriteManager.toggleFavoriteHospital(hospital);
                      setState(() {}); // ✅ UI 갱신
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }*/

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
                      _searchHospitalsAndShowModal();
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
