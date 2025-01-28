import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:forlong/screens/reservation_screen.dart';
import '../../models/hospital.dart';
import '../widgets/custom_widgets.dart';

class HospitalDetailScreen extends StatefulWidget {
  final Hospital hospital; // 병원 정보 모델

  const HospitalDetailScreen({super.key, required this.hospital});

  @override
  _HospitalDetailScreenState createState() => _HospitalDetailScreenState();
}

class _HospitalDetailScreenState extends State<HospitalDetailScreen> {
  bool isBookmarked = false; // 찜 여부 상태 변수
  bool _isMapInteracting = false; // 지도 조작 여부 상태
  late NaverMapController _mapController;

  void _onMapReady(NaverMapController controller) {
    setState(() {
      _mapController = controller;
      _addHospitalMarker(widget.hospital);
    });
  }

  void _addHospitalMarker(Hospital hospital) {
    if (hospital.markerImagePath != null &&
        hospital.markerImagePath!.isNotEmpty) {
      final marker = NMarker(
        id: hospital.name,
        position: NLatLng(hospital.latitude, hospital.longitude),
        icon:
            NOverlayImage.fromFile(File(hospital.markerImagePath!)), // 파일 경로 사용
      );

      _mapController.addOverlay(marker);
      _mapController.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(hospital.latitude, hospital.longitude),
          zoom: 16,
        ),
      );
    } else {
      print("마커 이미지 경로가 없습니다: ${hospital.name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.hospital.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    '이미지를 불러올 수 없습니다.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // 지도를 조작 중일 때 스크롤 이벤트를 막음
                  return _isMapInteracting;
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    physics: _isMapInteracting
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  CustomWidgets.buildTag(widget.hospital.status, const Color(0xdd5361f9)),
                                  const SizedBox(width: 8),
                                  CustomWidgets.buildTag(widget.hospital.region, Colors.grey[300]!),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.hospital.name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              CustomWidgets.buildInfoRow('위치', widget.hospital.location),
                              CustomWidgets.buildInfoRow('연락처', widget.hospital.phone),
                              CustomWidgets.buildInfoRow('홈페이지', widget.hospital.website, isLink: true),
                              const SizedBox(height: 12),
                              const Text(
                                '병원 정보',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.hospital.description,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Divider(color: Colors.grey[300]),
                              const Text(
                                '주소',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Color(0xff616a61), size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.hospital.location,
                                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // 네이버 지도 UI 추가
                              Container(
                                height: 400,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey, width: 0.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: GestureDetector(
                                    onScaleUpdate: (details) async {
                                      final currentPosition = await _mapController.getCameraPosition();
                                      double zoomAdjustmentFactor = 0.5;
                                      double newZoom = currentPosition.zoom +
                                          (details.scale - 1) * zoomAdjustmentFactor;

                                      newZoom = newZoom.clamp(3.0, 21.0);

                                      await _mapController.updateCamera(
                                        NCameraUpdate.withParams(
                                          target: currentPosition.target,
                                          zoom: newZoom,
                                        ),
                                      );
                                    },
                                    child: NaverMap(
                                      onMapReady: _onMapReady,
                                      options: NaverMapViewOptions(
                                        initialCameraPosition: NCameraPosition(
                                          target: NLatLng(widget.hospital.latitude, widget.hospital.longitude),
                                          zoom: 16,
                                        ),
                                        minZoom: 3,
                                        maxZoom: 21,
                                        zoomGesturesEnable: true,
                                        scrollGesturesEnable: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                padding: const EdgeInsets.only(right: 15),
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 30,
                  color: isBookmarked ? const Color(0xff4DAEEB) : Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReservationScreen(hospital: widget.hospital),
                    ),
                  ); // 예약 기능 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1BB881),
                  minimumSize: const Size(290, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                label: const Text(
                  '예약하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
